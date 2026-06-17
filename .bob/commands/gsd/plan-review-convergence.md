---
name: gsd:plan-review-convergence
description: Cross-AI plan convergence loop — replan with review feedback until no HIGH concerns remain.
argument-hint: "<phase> [--max-cycles N] [--codex] [--gemini] [--claude] [--opencode] [--ollama] [--all]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
requires: [plan-phase, review]
---
<objective>
Cross-AI plan convergence loop. Repeatedly: runs `gsd-plan-phase` inline → spawns an Agent for `gsd-review` → checks unresolved HIGH / actionable non-HIGH concerns → replans with `--reviews` feedback → re-reviews.

Stops when concerns resolve or `--max-cycles N` (default 3) is reached.

Feature-gated behind `workflow.plan_review_convergence=true`.
Enable with: `/gsd:config` → toggle plan_review_convergence.
</objective>

<execution_context>
@~/.bob/gsd-core/workflows/plan-review-convergence.md
</execution_context>

<context>
Phase: $ARGUMENTS (first token)

**Flags:**
- `--max-cycles N` — maximum convergence iterations (default: 3)
- `--codex`, `--gemini`, `--claude`, `--opencode`, `--ollama`, `--lm-studio`, `--llama-cpp`, `--all` — reviewer selectors forwarded to `gsd-review`
</context>

<process>
Execute end-to-end.
Preserve all workflow gates (config check, cycle limit, unresolved concern detection, replan trigger).
</process>
