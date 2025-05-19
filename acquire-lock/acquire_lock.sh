#!/bin/bash
set -euo pipefail

LOCK_FILE=".locks/${LOCK_NAME}.lock"
WORKDIR="lock-repo"

git config --global user.name "ci-lock"
git config --global user.email "ci-lock@github"

git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${LOCK_REPO}.git" "$WORKDIR"
cd "$WORKDIR"
git checkout "${LOCK_BRANCH:-main}"

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
ATTEMPT=0

while true; do
  ((ATTEMPT++))
  echo "🔐 Attempt $ATTEMPT to acquire lock..."

  git pull --rebase origin "${LOCK_BRANCH:-main}" || true
  git add "$LOCK_FILE"

  if git commit -m "acquire-lock: $LOCK_NAME by $LOCKED_BY"; then
    if git push origin HEAD; then
      echo "✅ Lock acquired on attempt $ATTEMPT"
      break
    fi
  else
    echo "ℹ️  Nothing to commit on attempt $ATTEMPT"
    break
  fi

  if [[ "$RETRY_COUNT" -ne 0 && "$ATTEMPT" -ge "$RETRY_COUNT" ]]; then
    echo "❌ Failed to acquire lock after $RETRY_COUNT attempts."
    exit 1
  fi

  echo "⏳ Waiting $RETRY_DELAY seconds before retry..."
  sleep "$RETRY_DELAY"
done