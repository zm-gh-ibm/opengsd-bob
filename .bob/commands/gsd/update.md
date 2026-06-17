---
name: gsd:update
description: Update GSD to latest version with changelog display
argument-hint: "[--sync | --reapply | --next | --rc]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
---

<objective>
Check for GSD updates, install if available, and display what changed.

Routes to the update workflow which handles:
- Version detection (local vs global installation)
- npm version checking
- Changelog fetching and display
- User confirmation with clean install warning
- Update execution and cache clearing
- Restart reminder
</objective>

<execution_context>
@~/.bob/gsd-core/workflows/update.md
</execution_context>

<flags>
- **--sync**: Sync managed GSD skills across runtime roots so multi-runtime users stay aligned after an update.
- **--reapply**: Reapply local modifications after a GSD update (three-way merge).
- **--next** (alias **--rc**): Target the `@next` RC dist-tag instead of `@latest`.
- **(no flag)**: Standard update — check for new version, show changelog, install.
</flags>

<process>
Parse the first token of $ARGUMENTS:
- If it is `--sync`: strip the flag, execute the sync-skills workflow.
- If it is `--reapply`: strip the flag, execute the reapply-patches workflow.
- Otherwise (including `--next` / `--rc`): execute the update workflow end-to-end.
</process>

<execution_context_extended>
@~/.bob/gsd-core/workflows/sync-skills.md
@~/.bob/gsd-core/workflows/reapply-patches.md
</execution_context_extended>
