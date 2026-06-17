---
name: gsd:profile-user
description: Generate developer behavioral profile and create Claude-discoverable artifacts
argument-hint: "[--questionnaire] [--refresh]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
---
<objective>
Generates a developer behavioral profile from session analysis (or questionnaire fallback).
Produces `USER-PROFILE.md`, a `gsd-dev-preferences` skill config, and a CLAUDE.md/BOB.md section.

**Flags:**
- `--questionnaire` — skip session analysis, use structured questionnaire
- `--refresh` — rebuild with diff from prior profile
</objective>

<execution_context>
@~/.bob/gsd-core/workflows/profile-user.md
</execution_context>

<process>
Execute end-to-end.
</process>
