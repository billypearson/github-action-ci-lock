#!/bin/bash
set -euo pipefail

LOCK_FILE=".locks/${LOCK_NAME}.lock"
WORKDIR="lock-repo"

git config --global user.name "ci-lock"
git config --global user.email "ci-lock@github"

git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${LOCK_REPO}.git" "$WORKDIR"
cd "$WORKDIR"
git checkout "${LOCK_BRANCH:-main}"

mkdir -p .locks

LOCK_CONTENT=$(jq -nc \
  --arg by "${LOCKED_BY}" \
  --arg time "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
  --arg ref "${REF:-}" \
  --arg sha "${SHA:-}" \
  --arg src "${SOURCE:-}" \
  '{locked_by: $by, timestamp: $time, ref: $ref, sha: $sha, source: $src}')

ENCODED_CONTENT=$(echo "$LOCK_CONTENT" | base64 -w 0)

echo "$ENCODED_CONTENT" > "$LOCK_FILE"

git add "$LOCK_FILE"
git commit -m "acquire-lock: $LOCK_NAME by $LOCKED_BY"
git push origin HEAD