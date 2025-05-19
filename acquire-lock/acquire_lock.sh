#!/bin/bash
set -euxo pipefail

# Set a 5-minute timeout to avoid hanging indefinitely
exec timeout 3600 "$0" "$@"

LOCK_FILE=".locks/${LOCK_NAME}.lock"
WORKDIR="lock-repo"

git config --global user.name "ci-lock"
git config --global user.email "ci-lock@github"

rm -rf "$WORKDIR"

git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${LOCK_REPO}.git" "$WORKDIR"
cd "$WORKDIR"
git checkout "${LOCK_BRANCH:-main}"

if ! git rev-parse --verify "${LOCK_BRANCH:-main}" >/dev/null 2>&1; then
  echo "❌ Branch ${LOCK_BRANCH:-main} does not exist in ${LOCK_REPO}"
  exit 1
fi

mkdir -p "$(dirname "$LOCK_FILE")"

LOCK_CONTENT=$(jq -nc \
  --arg by "${LOCKED_BY}" \
  --arg time "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
  --arg ref "${REF:-}" \
  --arg sha "${SHA:-}" \
  --arg src "${SOURCE:-}" \
  '{locked_by: $by, timestamp: $time, ref: $ref, sha: $sha, source: $src}')

ENCODED_CONTENT=$(echo "$LOCK_CONTENT" | base64 -w 0)

echo "$ENCODED_CONTENT" > "$LOCK_FILE"


# Retry logic for acquiring the lock
RETRY_COUNT="${RETRY_COUNT:-3}"
RETRY_DELAY="${RETRY_DELAY:-5}"
MAX_TOTAL_ATTEMPTS=60
ATTEMPT=0

while (( ATTEMPT < MAX_TOTAL_ATTEMPTS )); do
  ((ATTEMPT++))
  echo "🔐 Attempt $ATTEMPT to acquire lock..."

  git pull --rebase origin "${LOCK_BRANCH:-main}" || true
  git add "$LOCK_FILE"

  if git commit -m "acquire-lock: $LOCK_NAME by $LOCKED_BY"; then
    if git push origin HEAD; then
      echo "✅ Lock acquired on attempt $ATTEMPT"

      echo "🔍 Verifying lock ownership..."

      git pull --rebase origin "${LOCK_BRANCH:-main}" || true
      ACTUAL_CONTENT=$(base64 -d "$LOCK_FILE" | jq -r '.sha + "|" + .locked_by')

      if [[ "$ACTUAL_CONTENT" != "${SHA}|${LOCKED_BY}" ]]; then
        echo "❌ Lock file content mismatch. Another process acquired the lock."
        exit 1
      fi

      echo "✅ Verified lock ownership."
      break
    else
      echo "❌ git push failed on attempt $ATTEMPT. Dumping status:"
      git status || true
      git remote -v || true
      git branch -vv || true
      echo "Last 20 log lines:"
      git log -20 --oneline --decorate --graph || true
      # Don't exit here, just retry below
    fi
  else
    echo "ℹ️  Nothing to commit on attempt $ATTEMPT (lock already held or unchanged). Exiting successfully."
    exit 0
  fi

  # Only enforce RETRY_COUNT if RETRY_COUNT is greater than 0
  if [[ "$RETRY_COUNT" -gt 0 && "$ATTEMPT" -ge "$RETRY_COUNT" ]]; then
    echo "❌ Failed to acquire lock after $RETRY_COUNT attempts."
    exit 1
  fi

  echo "⏳ Waiting $RETRY_DELAY seconds before retry..."
  sleep "$RETRY_DELAY"
done

echo "❌ Timeout acquiring lock after $MAX_TOTAL_ATTEMPTS attempts."
exit 1