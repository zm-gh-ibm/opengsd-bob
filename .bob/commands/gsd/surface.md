---
name: gsd:surface
description: Toggle which skills are surfaced — apply a profile, list, or disable a cluster without reinstall
argument-hint: "[list|status|profile <name>|disable <cluster>|enable <cluster>|reset]"
allowed-tools:
  - Read
  - Write
  - Bash
requires: [config, update]
---

<objective>
Manage the runtime skill surface without reinstall. Reads/writes `~/.bob/.gsd-surface.json`
and re-stages the active skills directory in place.
Skill dirs live at `~/.bob/skills/gsd-*/`.

Sub-commands: list · status · profile · disable · enable · reset
</objective>

## Sub-command routing

Parse the first token of $ARGUMENTS:

| Token | Action |
|---|---|
| `list` | Show enabled + disabled clusters and skills |
| `status` | Alias for `list` plus token cost summary |
| `profile <name>` | Write `baseProfile` and re-stage |
| `profile <n1>,<n2>` | Composed profiles (comma-separated, no spaces) |
| `disable <cluster>` | Add cluster to `disabledClusters`, re-stage |
| `enable <cluster>` | Remove cluster from `disabledClusters`, re-stage |
| `reset` | Delete `.gsd-surface.json`, return to install-time profile |
| *(none)* | Treat as `list` |

<execution_context>
@~/.bob/gsd-core/workflows/surface.md
</execution_context>

<process>
Execute end-to-end following the sub-command routing table.
</process>
