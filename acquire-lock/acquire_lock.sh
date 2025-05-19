#!/bin/bash
set -eu pipefail

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


# Retry logic for acquiring the lock
RETRY_COUNT="${RETRY_COUNT:-3}"
RETRY_DELAY="${RETRY_DELAY:-5}"
MAX_TOTAL_ATTEMPTS=60
ATTEMPT=0

while true; do
    (( ++ATTEMPT ))
    echo "🔐 Attempt $ATTEMPT to acquire lock..."

    git pull --rebase origin "${LOCK_BRANCH:-main}" || true

    if [[ -f "$LOCK_FILE" ]]; then
      EXISTING_CONTENT=$(base64 -d "$LOCK_FILE" | jq -r '.sha + "|" + .locked_by')
      if [[ "$EXISTING_CONTENT" != "${SHA}|${LOCKED_BY}" ]]; then
        echo "🔒 Lock already held by another job: $EXISTING_CONTENT"
        echo "⏳ Waiting $RETRY_DELAY seconds before retry..."
        if [[ "$RETRY_COUNT" -gt 0 && "$ATTEMPT" -ge "$RETRY_COUNT" ]]; then
          echo "❌ Failed to acquire lock after $RETRY_COUNT attempts."
          exit 1
        fi
        if (( ATTEMPT >= MAX_TOTAL_ATTEMPTS )); then
          echo "❌ Timeout acquiring lock after $MAX_TOTAL_ATTEMPTS attempts."
          exit 1
        fi
        sleep "$RETRY_DELAY"
        continue
      else
        echo "⚠️ Lock file already exists and is held by current job. No action needed."
        exit 0
      fi
    fi

    echo "$ENCODED_CONTENT" > "$LOCK_FILE"

    git add "$LOCK_FILE"

    if git commit -m "acquire-lock: $LOCK_NAME by $LOCKED_BY"; then
        if git push origin HEAD; then
            echo "✅ Lock acquired on attempt $ATTEMPT"

            echo "🔍 Verifying lock ownership..."
            git stash --include-untracked || true
            git pull --rebase origin "${LOCK_BRANCH:-main}" || true
            git stash pop || true
            ACTUAL_CONTENT=$(base64 -d "$LOCK_FILE" | jq -r '.sha + "|" + .locked_by')

            if [[ "$ACTUAL_CONTENT" != "${SHA}|${LOCKED_BY}" ]]; then
                echo "❌ Lock file content mismatch. Another process acquired the lock."
                exit 1
            fi

            echo "✅ Verified lock ownership."

            # Ensure the lock file still matches post-rebase before exiting loop
            ACTUAL_CONTENT=$(base64 -d "$LOCK_FILE" | jq -r '.sha + "|" + .locked_by')
            if [[ "$ACTUAL_CONTENT" != "${SHA}|${LOCKED_BY}" ]]; then
                echo "❌ Race condition detected. Lock overwritten after verification."
                exit 1
            fi

            break
        else
            echo "❌ git push failed on attempt $ATTEMPT. Dumping status:"
            git status || true
            git remote -v || true
            git branch -vv || true
            echo "Last 20 log lines:"
            git log -20 --oneline --decorate --graph || true
        fi
    else
        echo "ℹ️  Nothing to commit on attempt $ATTEMPT (lock already held or unchanged). Exiting successfully."
        exit 0
    fi

    if [[ "$RETRY_COUNT" -gt 0 && "$ATTEMPT" -ge "$RETRY_COUNT" ]]; then
        echo "❌ Failed to acquire lock after $RETRY_COUNT attempts."
        exit 1
    fi

    if (( ATTEMPT >= MAX_TOTAL_ATTEMPTS )); then
        echo "❌ Timeout acquiring lock after $MAX_TOTAL_ATTEMPTS attempts."
        exit 1
    fi

    echo "⏳ Waiting $RETRY_DELAY seconds before retry..."
    sleep "$RETRY_DELAY"
done

if (( ATTEMPT >= MAX_TOTAL_ATTEMPTS )); then
    echo "❌ Timeout acquiring lock after $MAX_TOTAL_ATTEMPTS attempts."
    exit 1
fi