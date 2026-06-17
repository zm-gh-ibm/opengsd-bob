# GSD for Bob

> **GSD (Get Shit Done)** slash commands and agents for IBM Bob — spec-driven development, project planning, and autonomous coding workflows.

All 68 GSD slash commands from [`open-gsd/gsd-core`](https://github.com/open-gsd/gsd-core) — adapted for IBM Bob's `.bob/commands/` format, with full `@~/.bob/gsd-core/` path mapping.

---

## One-liner Install

```bash
curl -fsSL https://raw.githubusercontent.com/zm-gh-ibm/opengsd-bob/main/install.sh | bash
```

Or with a specific version:

```bash
GSD_CORE_VERSION="1.5.0" curl -fsSL https://raw.githubusercontent.com/zm-gh-ibm/opengsd-bob/main/install.sh | bash
```

---

## What Gets Installed

| Location | Contents |
|---|---|
| `~/.bob/commands/gsd/` | 68 GSD slash commands |
| `~/.bob/agents/` | 34 GSD specialist agents |
| `~/.bob/gsd-core/` | gsd-core runtime (workflows, templates, references) |

---

## Requirements

- **IBM Bob** (latest version)
- **Node.js** 18+ (for `gsd-tools` CLI)
- **npm / npx** (for installing gsd-core runtime)
- **git** (optional, for runtime fallback install)

---

## Quick Start

After installing, open any project in Bob and run:

```
/gsd:new-project        — Initialize GSD for a new project
/gsd:new-project --auto — Initialize with minimal interaction
/gsd:progress           — Check current project status (existing projects)
/gsd:help               — Browse all available commands
```

---

## All Commands

### 🔄 Core Workflow
| Command | Description |
|---|---|
| `/gsd:new-project` | Initialize a new project with PROJECT.md and ROADMAP.md |
| `/gsd:discuss-phase` | Gather context through adaptive questioning |
| `/gsd:plan-phase` | Create detailed phase plan (PLAN.md) |
| `/gsd:execute-phase` | Execute all plans with wave-based parallelization |
| `/gsd:verify-work` | Validate built features through conversational UAT |
| `/gsd:progress` | Check progress, advance workflow, or dispatch intent |

### 📋 Phase Management
| Command | Description |
|---|---|
| `/gsd:phase` | Add, insert, remove, or edit phases in ROADMAP.md |
| `/gsd:spec-phase` | Clarify phase requirements with ambiguity scoring |
| `/gsd:mvp-phase` | Plan a phase as a vertical MVP slice |
| `/gsd:pause-work` | Create context handoff when pausing |
| `/gsd:resume-work` | Resume from previous session |

### 🏁 Milestone Lifecycle
| Command | Description |
|---|---|
| `/gsd:new-milestone` | Start a new milestone cycle |
| `/gsd:audit-milestone` | Audit milestone completion before archiving |
| `/gsd:complete-milestone` | Archive milestone and prepare next version |
| `/gsd:milestone-summary` | Generate team onboarding summary |

### 🔍 Quality Gates
| Command | Description |
|---|---|
| `/gsd:code-review` | Review code for bugs and security issues |
| `/gsd:audit-uat` | Cross-phase UAT and verification audit |
| `/gsd:secure-phase` | Verify threat mitigations |
| `/gsd:validate-phase` | Audit Nyquist validation gaps |
| `/gsd:eval-review` | Audit AI phase evaluation coverage |
| `/gsd:ui-review` | 6-pillar visual audit of frontend code |
| `/gsd:audit-fix` | Autonomous audit-to-fix pipeline |

### 🧠 Intelligence
| Command | Description |
|---|---|
| `/gsd:map-codebase` | Analyze codebase with parallel mapper agents |
| `/gsd:graphify` | Build knowledge graph of .planning/ |
| `/gsd:docs-update` | Generate or update project documentation |
| `/gsd:extract-learnings` | Extract lessons from completed phases |
| `/gsd:mempalace-recall` | Recall prior decisions from MemPalace |
| `/gsd:mempalace-capture` | File phase artifacts into MemPalace |

### 🎨 Ideation
| Command | Description |
|---|---|
| `/gsd:explore` | Socratic ideation before committing to plans |
| `/gsd:sketch` | Throwaway HTML mockups for UI design |
| `/gsd:spike` | Time-boxed technical exploration |
| `/gsd:capture` | Capture notes, todos, seeds, backlog items |

### ⚙️ Management
| Command | Description |
|---|---|
| `/gsd:config` | Configure GSD workflow settings |
| `/gsd:update` | Update GSD to latest version |
| `/gsd:health` | Diagnose planning directory health |
| `/gsd:ship` | Create PR after verification passes |
| `/gsd:stats` | Display project statistics |
| `/gsd:debug` | Systematic debugging with persistent state |

### 🔧 Power Features
| Command | Description |
|---|---|
| `/gsd:autonomous` | Run all remaining phases autonomously |
| `/gsd:plan-review-convergence` | Cross-AI plan convergence loop |
| `/gsd:quick` | Quick tasks with GSD guarantees |
| `/gsd:fast` | Trivial inline tasks, no planning overhead |
| `/gsd:workstreams` | Manage parallel workstreams |

---

## How It Works

### Path Mapping

GSD for Bob uses `~/.bob/gsd-core/` instead of `~/.claude/gsd-core/` for all workflow references:

| Claude Path | Bob Path |
|---|---|
| `@~/.claude/gsd-core/workflows/` | `@~/.bob/gsd-core/workflows/` |
| `@~/.claude/gsd-core/templates/` | `@~/.bob/gsd-core/templates/` |
| `@~/.claude/gsd-core/references/` | `@~/.bob/gsd-core/references/` |

### Agent Architecture

Agents are loaded from the gsd-core runtime at `~/.bob/gsd-core/agents/`. The stub files in `.bob/agents/` contain metadata and an `@~/.bob/gsd-core/agents/` include that loads the full agent prompt at runtime.

### .planning/ Directory

GSD stores all project state in `.planning/` — the same as the Claude version. No changes required.

---

## Manual Installation

### Step 1: Clone this repo

```bash
git clone https://github.com/YOUR_ORG/gsd-bob.git
cd gsd-bob
```

### Step 2: Copy commands and agents

```bash
mkdir -p ~/.bob/commands/gsd ~/.bob/agents
cp .bob/commands/gsd/*.md ~/.bob/commands/gsd/
cp .bob/agents/*.md ~/.bob/agents/
```

### Step 3: Install gsd-core runtime

```bash
# Option A: npm (recommended)
npx -y @opengsd/gsd-core@latest --target ~/.bob

# Option B: git clone
git clone --depth=1 --branch next \
  https://github.com/open-gsd/gsd-core.git \
  ~/.bob/gsd-core
```

---

## Update

```bash
# Re-run the installer (safe to run multiple times)
curl -fsSL https://raw.githubusercontent.com/zm-gh-ibm/opengsd-bob/main/install.sh | bash
```

Or from within Bob:

```
/gsd:update
```

---

## Differences from Claude Code Version

| Aspect | Claude Code | Bob |
|---|---|---|
| Command location | `~/.claude/commands/gsd/` | `~/.bob/commands/gsd/` |
| Agent location | `~/.claude/agents/` | `~/.bob/agents/` |
| Runtime location | `~/.claude/gsd-core/` | `~/.bob/gsd-core/` |
| Tool: AskUserQuestion | `AskUserQuestion` | `vscode_askquestions` (same API) |
| gsd-tools shim | `~/.claude/gsd-core/bin/` | `~/.bob/gsd-core/bin/` (priority) |
| Slash command prefix | `/gsd:` | `/gsd:` |
| `.planning/` directory | same | same |

All workflow logic, agents, and `.planning/` artifacts are 100% compatible between Claude Code and Bob. You can switch between both tools on the same project without any migration.

---

## Source

Commands adapted from: [`open-gsd/gsd-core`](https://github.com/open-gsd/gsd-core) (branch: `next`)  
License: MIT
