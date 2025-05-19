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

| Input       | Required | Description |
|-------------|----------|-------------|
| `lock_name` | ✅       | Unique name of the lock file |
| `lock_repo` | ✅       | Target repo to store the lock |
| `github_token` | ✅   | Token with write access to lock_repo |
| `locked_by` | ✅       | ID of the actor acquiring the lock |
| `ref`, `sha`, `source` | Optional | Metadata fields for traceability |

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

```yaml
- name: Acquire Lock
  uses: billypearson/github-action-ci-lock/acquire-lock@v1
  with:
    lock_name: agent-release
    lock_repo: billypearson/ci-lock-state
    github_token: ${{ secrets.PAT }}
    locked_by: releasebot
    sha: ${{ github.sha }}
    source: "workflow:agent-release"
```

### Release Lock

```yaml
- name: Release Lock
  if: always()
  uses: billypearson/github-action-ci-lock/release-lock@v1
  with:
    lock_name: agent-release
    lock_repo: billypearson/ci-lock-state
    github_token: ${{ secrets.PAT }}
```

---

## Contributing

Pull requests and feedback are welcome! If you have suggestions or encounter issues, feel free to open an issue or PR.

---

## License

MIT – see [LICENSE](LICENSE) for full details.
