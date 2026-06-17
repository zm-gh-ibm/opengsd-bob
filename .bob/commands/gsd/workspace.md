---
name: gsd:workspace
description: Manage GSD workspaces — create, list, or remove isolated workspace environments
argument-hint: "[--new | --list | --remove] [name]"
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

<objective>
Manage GSD workspaces with a single consolidated command.

Mode routing:
- **--new**: Create an isolated workspace with repo copies and independent .planning/ → new-workspace workflow
- **--list**: List active GSD workspaces and their status → list-workspaces workflow
- **--remove**: Remove a GSD workspace and clean up worktrees → remove-workspace workflow
</objective>

<routing>
| Flag | Action | Workflow |
|------|--------|----------|
| --new | Create workspace with worktree/clone strategy | new-workspace |
| --list | Scan ~/gsd-workspaces/, show summary table | list-workspaces |
| --remove | Confirm and remove workspace directory | remove-workspace |
</routing>

<execution_context>
@~/.bob/gsd-core/workflows/new-workspace.md
@~/.bob/gsd-core/workflows/list-workspaces.md
@~/.bob/gsd-core/workflows/remove-workspace.md
@~/.bob/gsd-core/references/ui-brand.md
</execution_context>

<context>
Arguments: $ARGUMENTS
Parse the first token of $ARGUMENTS:
- If `--new`: pass remainder to new-workspace workflow
- If `--list`: execute list-workspaces workflow
- If `--remove`: pass remainder to remove-workspace workflow
- Otherwise: show usage
</context>

<process>
1. Parse the leading flag from $ARGUMENTS.
2. Load and execute the appropriate workflow end-to-end.
3. Preserve all workflow gates.
</process>
