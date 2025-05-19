#!/bin/bash
set -euo pipefail

LOCK_FILE=".locks/${LOCK_NAME}.lock"
WORKDIR="lock-repo"

git config --global user.name "ci-lock"
git config --global user.email "ci-lock@github"

git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${LOCK_REPO}.git" "$WORKDIR"
cd "$WORKDIR"
git checkout "${LOCK_BRANCH:-main}"

if [[ -f "$LOCK_FILE" ]]; then
  git rm "$LOCK_FILE"
  git commit -m "release-lock: $LOCK_NAME"
  git push origin HEAD
else
  echo "🔓 Lock file not found: $LOCK_FILE"
fi