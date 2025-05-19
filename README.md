# GitHub Action – CI Lock

[![Release](https://img.shields.io/github/v/release/billypearson/github-action-ci-lock?label=version)](https://github.com/billypearson/github-action-ci-lock/releases)
[![License](https://img.shields.io/github/license/billypearson/github-action-ci-lock)](LICENSE)

Reusable GitHub Actions for distributed locking and CI coordination across repositories.

## Features

- 🔒 File-based locking across workflows and repos
- 📦 Lock metadata stored as base64-encoded JSON
- 📜 Auditable via git history
- ✅ Compatible with any GitHub-hosted repo

---

## Inputs

| Input          | Required | Description |
|----------------|----------|-------------|
| `lock_name`    | ✅       | Unique name of the lock file |
| `lock_repo`    | ✅       | GitHub repo to store the lock (e.g. `billypearson/ci-lock-state`) |
| `github_token` | ✅       | Token with write access to `lock_repo` |
| `locked_by`    | ✅       | ID of the actor acquiring the lock (e.g., `releasebot`) |
| `ref`          | ❌       | Git ref for context (e.g., `refs/heads/main`) |
| `sha`          | ❌       | Commit SHA for traceability |
| `source`       | ❌       | Optional context label (e.g., workflow name) |
| `retry_count`  | ❌       | Number of retry attempts (default: `3`, `0` = unlimited) |
| `retry_delay`  | ❌       | Delay between retries in seconds (default: `5`) |

---

## Getting Started

To use these GitHub Actions, add them to your workflow with the appropriate inputs. You must have a secondary repository (e.g. `ci-lock-state`) that stores the lock files.

---

## Token Permissions

You must pass a GitHub token with the following scopes:
- `repo` – to push lock files to the lock state repository
- `workflow` – (optional) if using this in workflow dispatch or reusable workflows

---

## Usage

### Acquire Lock

This step acquires a lock by writing a `.locks/<lock_name>.lock` file to the specified repo. It stores metadata like who acquired the lock and when.

```yaml
- name: Acquire Lock
  uses: billypearson/github-action-ci-lock/acquire-lock@v1
  with:
    lock_name: agent-release                # Unique identifier for this lock
    lock_repo: billypearson/ci-lock-state   # Repo that stores the lock file
    github_token: ${{ secrets.PAT }}        # GitHub token with write access to lock_repo
    locked_by: releasebot                   # Tag the lock holder (bot, user, etc.)
    sha: ${{ github.sha }}                  # (optional) Commit SHA
    source: "workflow:agent-release"        # (optional) Contextual source description
    retry_count: 5                          # (optional) Retry up to 5 times
    retry_delay: 10                         # (optional) Wait 10s between retries
```

### Release Lock

This step removes the lock file from the lock state repository. It should run in `finally`/`if: always()` to ensure cleanup.

```yaml
- name: Release Lock
  if: always()
  uses: billypearson/github-action-ci-lock/release-lock@v1
  with:
    lock_name: agent-release                # Match the lock name used earlier
    lock_repo: billypearson/ci-lock-state   # Same repo used for storing locks
    github_token: ${{ secrets.PAT }}        # GitHub token with write access
```

---

## Contributing

Pull requests and feedback are welcome! If you have suggestions or encounter issues, feel free to open an issue or PR.

---

## License

MIT – see [LICENSE](LICENSE) for full details.
