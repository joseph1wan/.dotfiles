---
name: wt
description: Use when creating, listing, switching, testing, or removing git worktrees on this machine. Triggers on: new worktree, git worktree add, parallel branch work, feature stack, isolated E2E, wt new/ls/cd/env/test/down/rm/up/reset/build/pull/bt/logs/inspect/context, branch slug, STACK_URL, eval wt env.
---

# wt — Worktree Lifecycle Manager

## Core Rule

**Never run `git worktree add` directly.** Always use `wt new`. It creates the worktree AND registers the feature stack so `wt ls` tracks it.

## Script location

`wt` lives at `cp-workflows/local_setup/scripts/wt` (symlinked to `~/bin/wt`).
`SETUP_DIR` is self-derived from the script path — no `~/bin/.env` needed.
`LOCAL_SETUP_DIR` is set in `content-platform/.envrc` to `cp-workflows/local_setup/`.

## Layout

```
~/worktrees/{repo-name}/{branch-slug}/   worktree checkouts
~/.wt/{repo-name}/{branch-slug}.env      stack env vars (STACK_URL etc.)
```

Slug rule: lowercase, `/` and `_` → `-`, non-alnum-dash stripped, truncated to 24 chars, trailing dashes removed.
Examples: `feat/my-feature` → `feat-my-feature`, `fix/transform_fail` → `fix-transform-fail`

## Commands

### Lifecycle

```bash
wt new [--from=<base>] [--api=<path>] [--fw=<path>] feat/my-feature   # infer repo from cwd
wt new [--from=<base>] [--api=<path>] [--fw=<path>] ~/path/to/repo feat/my-feature

wt up [--api=<path>] [--fw=<path>] [repo] <branch>   # start stack for existing worktree (no git worktree add)
wt reset [repo] <branch>                              # stop + wipe data + restart (keeps worktree)
wt down [repo] <branch>                               # docker compose stop (keeps volumes + state)
wt rm [--force] [repo] <branch>                       # full teardown: stack + worktree + state
```

### Navigation

```bash
wt ls [--json]           # list all worktrees + stack status (* = dirty, numbered)
eval "$(wt cd 1)"        # cd to Nth entry from wt ls
eval "$(wt env)"                                   # load stack vars from cwd
eval "$(wt env cp-workflows feat/my-feature)"      # explicit
```

### Development loop

```bash
wt build [--baseline] [repo] <branch>                  # rebuild worker container in-place
wt pull [repo] <branch>                                # merge origin/<BASE_BRANCH> into worktree
wt test [--baseline] [repo] <branch> [path] [-- pytest-args]   # run e2e pytest suite
wt bt [--baseline] [repo] <branch> [path]              # build + test in one command
```

`--baseline`: targets the running baseline stack (`http://localhost:8000`, namespace `content-platform-dev`) instead of the feature stack.

### Diagnostics

```bash
wt logs [service] [--follow] [--tail=N] [--json]   # tail container logs (default: worker, last 200)
wt inspect [--json]     # container health + DynamoDB table counts + OpenSearch doc counts
wt context [--tail=N] [--json]   # full diagnostic bundle: containers + logs + git status
```

## After `wt new`

Always run `eval "$(wt env)"` to load `STACK_NAME`, `STACK_URL`, `TEMPORAL_NAMESPACE` into the shell. Without it, E2E tests hit the wrong stack.

## Finding a Branch's Worktree

Given branch `feat/my-feature` in `cp-workflows`:
→ worktree at `~/worktrees/cp-workflows/feat-my-feature/`

When working on a feature branch, `cd` to that path — the main repo checkout (`~/autodesk/content-platform/cp-workflows`) stays on `main`.

## cp-framework source injection (`CP_FRAMEWORK_SRC`)

`cp-workflows` tests prepend cp-framework source onto `sys.path` so local framework changes are picked up without publishing. Controlled by `CP_FRAMEWORK_SRC`.

`wt new` auto-resolves in priority order:
1. `--fw=<path>` flag (persisted in state file, reused by `wt up`)
2. Sibling cp-framework worktree on the **same branch slug** (`~/worktrees/cp-framework/<slug>/`)
3. `CP_FRAMEWORK_SRC` from `.envrc`

**When making cp-framework changes alongside cp-workflows changes:** create both worktrees on the same branch slug. `wt new` wires them automatically.

```bash
wt new ~/autodesk/content-platform/cp-framework feat/my-feature
wt new ~/autodesk/content-platform/cp-workflows feat/my-feature
# CP_FRAMEWORK_SRC in cp-workflows state → cp-framework worktree
```

## Temporal test server cache (`TEMPORAL_TEST_SERVER_DIR`)

Set in `.envrc`. Points `WorkflowEnvironment.start_time_skipping()` to a stable cache dir so the binary is only downloaded once. Unset on CI.

## State file format

`~/.wt/{repo}/{slug}.env` — only `export KEY="value"` lines. If corrupted (hash or `0` at top from stdout leak in `start-feature-stack.sh`), strip non-`export` lines manually.

## Port mismatch

`wt inspect` warns `⚠ Port mismatch` when state file ports differ from running containers (compose restarted and `_free_port` allocated different ports). Fix: `wt reset` (rewrites state file). Manual: `sed -i '' 's/old/new/' ~/.wt/{repo}/{slug}.env`.

## Baseline vs feature stack

| | Baseline | Feature stack |
|---|---|---|
| URL | `http://localhost:8000` | `http://localhost:<hash-port>` |
| Temporal namespace | `content-platform-dev` | `feature-<slug>` |
| DynamoDB | shared `cp-dynamodb-local` | isolated `cp-dynamodb-<slug>` |
| S3/RustFS | shared `cp-rustfs-local` | isolated `cp-rustfs-<slug>` |
| OpenSearch indices | `search-{content,chunk}-index-v2` | `<slug>-{content,chunk}-v2` |

Workers run in **hybrid mode**: Python worker handles activity tasks only (`CP_DISABLE_WORKFLOW_TASKS=true`), Go `worker-workflowtasks` handles workflow tasks (`CP_GO_WORKFLOW_WORKER=true`).

Temporal payloads bucket is per-stack: `cp-temporal-payloads-<slug>` (baseline: `cp-temporal-payloads-local`).

## Common Mistakes

| Mistake | Fix |
|---|---|
| `git worktree add` directly | Use `wt new` |
| Editing main repo instead of worktree | `cd ~/worktrees/{repo}/{slug}/` |
| E2E tests hit wrong stack | Run `eval "$(wt env)"` first |
| Stack not in `wt ls` | Was created without `wt new`; create state file manually at `~/.wt/{repo}/{slug}.env` |
| cp-framework changes not picked up | Create cp-framework worktree on same branch slug; `wt new` sets `CP_FRAMEWORK_SRC` automatically |
| State file has hash/`0` lines → `command not found` | Strip non-`export` lines; root cause is stdout leak in `start-feature-stack.sh` |
| `wt inspect` port mismatch | `wt reset` to rewrite state file with correct ports |
| Services not ready after 120s | Check `wt inspect` for port mismatch; if stale, run `wt reset` |
| `~/bin/.env` missing | No longer needed — `wt` is self-locating; `SETUP_DIR` derived from script path |
