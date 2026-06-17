---
name: gsd:graphify
description: "Build, query, and inspect the project knowledge graph in .planning/graphs/"
argument-hint: "[build|query <term>|status|diff]"
allowed-tools:
  - Read
  - Bash
requires: [config, fast, phase, update]
---

## Step 0 — Banner

Display `GSD > GRAPHIFY` banner before any tool calls. Then proceed.

## Step 1 — Config Gate

Read `.planning/config.json` directly with the Read tool.
Check `config.graphify.enabled === true`. If not enabled, print disabled message and stop.

## Step 2 — Parse argument and route

Parse the first token of $ARGUMENTS:

- **`query <term>`** — runs `gsd_run graphify query <term>`, displays matched nodes grouped by type with confidence tiers
- **`status`** — runs `gsd_run graphify status`, shows build time, node/edge counts, STALE/FRESH, commit staleness
- **`diff`** — runs `gsd_run graphify diff`, shows node/edge change counts
- **`build`** (or no arg) — proceed to Step 3

## Step 3 — Build (inline, no sub-agent)

```bash
_GSD_SHIM_NAME="gsd-tools.cjs"; _GSD_RUNTIME_ROOT="${RUNTIME_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"; GSD_TOOLS="${_GSD_RUNTIME_ROOT}/gsd-core/bin/${_GSD_SHIM_NAME}"; if [ -f "$GSD_TOOLS" ]; then gsd_run() { node "$GSD_TOOLS" "$@"; }; elif [ -f "${_GSD_RUNTIME_ROOT}/.bob/gsd-core/bin/${_GSD_SHIM_NAME}" ]; then GSD_TOOLS="${_GSD_RUNTIME_ROOT}/.bob/gsd-core/bin/${_GSD_SHIM_NAME}"; gsd_run() { node "$GSD_TOOLS" "$@"; }; elif [ -f "${_GSD_RUNTIME_ROOT}/.claude/gsd-core/bin/${_GSD_SHIM_NAME}" ]; then GSD_TOOLS="${_GSD_RUNTIME_ROOT}/.claude/gsd-core/bin/${_GSD_SHIM_NAME}"; gsd_run() { node "$GSD_TOOLS" "$@"; }; elif command -v gsd-tools >/dev/null 2>&1; then GSD_TOOLS="$(command -v gsd-tools)"; gsd_run() { "$GSD_TOOLS" "$@"; }; elif [ -f "$HOME/.bob/gsd-core/bin/${_GSD_SHIM_NAME}" ]; then GSD_TOOLS="$HOME/.bob/gsd-core/bin/${_GSD_SHIM_NAME}"; gsd_run() { node "$GSD_TOOLS" "$@"; }; elif [ -f "$HOME/.claude/gsd-core/bin/${_GSD_SHIM_NAME}" ]; then GSD_TOOLS="$HOME/.claude/gsd-core/bin/${_GSD_SHIM_NAME}"; gsd_run() { node "$GSD_TOOLS" "$@"; }; else echo "ERROR: gsd-tools not found. Run: npx -y @opengsd/gsd-core@latest --bob --local" >&2; exit 1; fi
gsd_run graphify update .
```

Copy artifacts to `.planning/graphs/`, write diff snapshot, report summary.
Timeout: 600 000 ms.

**DO NOT spawn sub-agents for this step.**
