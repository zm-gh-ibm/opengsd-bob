---
name: gsd:spec-phase
description: Clarify WHAT a phase delivers with ambiguity scoring; produces a SPEC.md before discuss-phase.
argument-hint: "<phase> [--auto] [--text]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
requires: [config, phase]
---
<objective>
Clarify phase requirements via a Socratic interview loop (up to 6 rounds, rotating perspectives) with quantitative ambiguity scoring across 4 weighted dimensions.

Gates on ambiguity ≤ 0.20 + all dimension minimums met, then writes `{phase_dir}/{padded_phase}-SPEC.md`.

Flags:
- `--auto` — skip questions, Claude chooses defaults
- `--text` — plain-text lists for remote/non-interactive sessions

Position in workflow: `spec-phase → discuss-phase → plan-phase → execute-phase → verify`
</objective>

<execution_context>
@~/.bob/gsd-core/workflows/spec-phase.md
@~/.bob/gsd-core/references/ui-brand.md
</execution_context>

<runtime_note>
**Bob (IBM):** Use `vscode_askquestions` wherever this workflow calls `AskUserQuestion`.
</runtime_note>

<context>
Phase: $ARGUMENTS (required)
</context>

<process>
Execute end-to-end.
Preserve all workflow gates (ambiguity gate, dimension minimums, SPEC.md write, routing).
</process>
