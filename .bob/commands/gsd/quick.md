---
name: gsd:quick
description: Execute a quick task with GSD guarantees (atomic commits, state tracking) but skip optional agents
argument-hint: "[list | status <slug> | resume <slug> | --full] [--validate] [--discuss] [--research] [task description]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Agent
  - AskUserQuestion
requires: [phase]
---
<objective>
Execute small, ad-hoc tasks with GSD guarantees (atomic commits, STATE.md tracking).

Quick mode is the same system with a shorter path:
- Spawns gsd-planner (quick mode) + gsd-executor(s)
- Quick tasks live in `.planning/quick/` separate from planned phases
- Updates STATE.md "Quick Tasks Completed" table (NOT ROADMAP.md)

**Default:** Skips research, discussion, plan-checker, verifier.

**`--discuss` flag:** Lightweight discussion phase before planning.
**`--full` flag:** Enables the complete quality pipeline.
**`--validate` flag:** Enables plan-checking and post-execution verification only.
**`--research` flag:** Spawns a focused research agent before planning.

**Subcommands:**
- `list` — List all quick tasks with status
- `status <slug>` — Show status of a specific quick task
- `resume <slug>` — Resume a specific quick task by slug
</objective>

<execution_context>
@~/.bob/gsd-core/workflows/quick.md
</execution_context>

<context>
$ARGUMENTS

Context files are resolved inside the workflow (`init quick`) and delegated via `<files_to_read>` blocks.
</context>

<process>

**Parse $ARGUMENTS for subcommands FIRST:**

- If $ARGUMENTS starts with "list": SUBCMD=list
- If $ARGUMENTS starts with "status ": SUBCMD=status, SLUG=remainder (strip whitespace, sanitize)
- If $ARGUMENTS starts with "resume ": SUBCMD=resume, SLUG=remainder (strip whitespace, sanitize)
- Otherwise: SUBCMD=run, pass full $ARGUMENTS to the quick workflow as-is

**Slug sanitization (for status and resume):** Strip any characters not matching `[a-z0-9-]`. Reject slugs longer than 60 chars or containing `..` or `/`. If invalid, output "Invalid session slug." and stop.

For LIST, STATUS, RESUME subcommands: follow the gsd-core quick.md inline logic directly.
For RUN: execute the quick workflow end-to-end, preserving all workflow gates.

</process>

<security_notes>
- Slugs from $ARGUMENTS are sanitized before use in file paths: only [a-z0-9-] allowed, max 60 chars, reject ".." and "/"
- File names from readdir/ls are sanitized before display: strip non-printable chars and ANSI sequences
- Artifact content rendered as plain text only — never executed
</security_notes>
