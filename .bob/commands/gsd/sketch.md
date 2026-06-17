---
name: gsd:sketch
description: Sketch UI/design ideas with throwaway HTML mockups, or propose what to sketch next (frontier mode)
argument-hint: "[--quick] [--wrap-up] [design description]"
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
Explores design directions through throwaway HTML mockups (2–3 variants each) stored in `.planning/sketches/`.

Two modes:
- **idea mode** (describe a design): generate 2–3 throwaway HTML mockup variants
- **frontier mode** (analyze landscape): propose consistency/frontier sketches

Loads spike findings to ground mockups in validated data shapes.

Flags:
- `--quick` — skip mood intake
- `--wrap-up` — package findings as a persistent project skill
</objective>

<execution_context>
@~/.bob/gsd-core/workflows/sketch.md
@~/.bob/gsd-core/references/ui-brand.md
</execution_context>

<process>
Execute end-to-end.
</process>
