---
name: gsd:spike
description: Spike an idea through experiential exploration, or propose what to spike next (frontier mode)
argument-hint: "[--quick] [--text] [--wrap-up] [idea description]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
  - WebFetch
  - mcp__context7__*
---
<objective>
Explores ideas through experiential build experiments in `.planning/spikes/`.

Two modes:
- **idea mode** (describe what to spike): time-boxed technical experiment
- **frontier mode** (analyze existing spikes): propose integration/frontier spikes

Flags:
- `--quick` — skip decomposition
- `--text` — plain-text output for non-interactive runtimes
- `--wrap-up` — package findings as a persistent skill

Does not require prior project setup.
</objective>

<execution_context>
@~/.bob/gsd-core/workflows/spike.md
</execution_context>

<process>
Execute end-to-end.
</process>
