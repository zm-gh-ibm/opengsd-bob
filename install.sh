#!/usr/bin/env bash
# ===========================================================================
# GSD for Bob — Install Script
# Installs GSD slash commands and agents into ~/.bob/
# 
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/gsd-bob/main/install.sh | bash
#
# Or clone and run:
#   git clone https://github.com/YOUR_ORG/gsd-bob.git && cd gsd-bob && bash install.sh
# ===========================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
REPO_URL="https://raw.githubusercontent.com/zm-gh-ibm/opengsd-bob/main"
BOB_HOME="${BOB_HOME:-$HOME/.bob}"
COMMANDS_DIR="$BOB_HOME/commands/gsd"
AGENTS_DIR="$BOB_HOME/agents"
GSD_CORE_BRANCH="${GSD_CORE_BRANCH:-next}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_info()    { echo -e "${CYAN}[gsd-bob]${NC} $*"; }
log_success() { echo -e "${GREEN}[gsd-bob]${NC} ✓ $*"; }
log_warn()    { echo -e "${YELLOW}[gsd-bob]${NC} ⚠ $*"; }
log_error()   { echo -e "${RED}[gsd-bob]${NC} ✗ $*" >&2; }
log_banner()  { echo -e "\n${BOLD}$*${NC}"; }

# ---------------------------------------------------------------------------
# Detect environment
# ---------------------------------------------------------------------------
check_dependencies() {
  local missing=()
  for cmd in curl; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    log_error "Missing required tools: ${missing[*]}"
    log_error "Please install them and re-run."
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# Install GSD commands into ~/.bob/commands/gsd/
# ---------------------------------------------------------------------------
install_commands() {
  log_banner "Installing GSD slash commands..."
  mkdir -p "$COMMANDS_DIR"

  local commands=(
    add-tests
    ai-integration-phase
    audit-fix
    audit-milestone
    audit-uat
    autonomous
    capture
    cleanup
    code-review
    complete-milestone
    config
    debug
    discuss-phase
    docs-update
    eval-review
    execute-phase
    explore
    extract-learnings
    fast
    forensics
    graphify
    health
    help
    import
    inbox
    ingest-docs
    manager
    map-codebase
    mempalace-capture
    mempalace-recall
    milestone-summary
    mvp-phase
    new-milestone
    new-project
    ns-context
    ns-ideate
    ns-manage
    ns-project
    ns-review
    ns-workflow
    pause-work
    phase
    plan-phase
    plan-review-convergence
    pr-branch
    profile-user
    progress
    quick
    resume-work
    review-backlog
    review
    secure-phase
    settings
    ship
    sketch
    spec-phase
    spike
    stats
    surface
    thread
    ui-phase
    ui-review
    ultraplan-phase
    undo
    update
    validate-phase
    verify-work
    workspace
    workstreams
  )

  local installed=0
  local failed=0

  for cmd in "${commands[@]}"; do
    local dest="$COMMANDS_DIR/${cmd}.md"
    if curl -fsSL "$REPO_URL/.bob/commands/gsd/${cmd}.md" -o "$dest" 2>/dev/null; then
      installed=$((installed + 1))
    else
      log_warn "Failed to download ${cmd}.md"
      failed=$((failed + 1))
    fi
  done

  log_success "Commands installed: $installed (failed: $failed)"
}

# ---------------------------------------------------------------------------
# Install GSD agents into ~/.bob/agents/
# ---------------------------------------------------------------------------
install_agents() {
  log_banner "Installing GSD agents..."
  mkdir -p "$AGENTS_DIR"

  local agents=(
    gsd-advisor-researcher
    gsd-ai-researcher
    gsd-assumptions-analyzer
    gsd-code-fixer
    gsd-code-reviewer
    gsd-codebase-mapper
    gsd-debug-session-manager
    gsd-debugger
    gsd-doc-classifier
    gsd-doc-synthesizer
    gsd-doc-verifier
    gsd-doc-writer
    gsd-domain-researcher
    gsd-eval-auditor
    gsd-eval-planner
    gsd-executor
    gsd-framework-selector
    gsd-integration-checker
    gsd-intel-updater
    gsd-mempalace-curator
    gsd-nyquist-auditor
    gsd-pattern-mapper
    gsd-phase-researcher
    gsd-plan-checker
    gsd-planner
    gsd-project-researcher
    gsd-research-synthesizer
    gsd-roadmapper
    gsd-security-auditor
    gsd-ui-auditor
    gsd-ui-checker
    gsd-ui-researcher
    gsd-user-profiler
    gsd-verifier
  )

  local installed=0
  local failed=0

  for agent in "${agents[@]}"; do
    local dest="$AGENTS_DIR/${agent}.md"
    if curl -fsSL "$REPO_URL/.bob/agents/${agent}.md" -o "$dest" 2>/dev/null; then
      installed=$((installed + 1))
    else
      log_warn "Failed to download ${agent}.md"
      failed=$((failed + 1))
    fi
  done

  log_success "Agents installed: $installed (failed: $failed)"
}

# ---------------------------------------------------------------------------
# Install gsd-core runtime (workflows, references, templates)
# Downloads files directly from open-gsd/gsd-core (next branch) via raw URLs.
# This mirrors the same curl-per-file pattern used for commands and agents,
# avoiding the npm --target flag ambiguity and git-clone subdirectory mismatch
# (the repo's runtime lives at gsd-core/workflows/ inside the repo, but must
# land at ~/.bob/gsd-core/workflows/ on disk).
# ---------------------------------------------------------------------------
install_gsd_core_runtime() {
  log_banner "Installing gsd-core runtime into ~/.bob/gsd-core/..."

  local GSD_CORE_DIR="$BOB_HOME/gsd-core"
  local CLAUDE_CORE_DIR="$HOME/.claude/gsd-core"
  local GSD_CORE_RAW="https://raw.githubusercontent.com/open-gsd/gsd-core/${GSD_CORE_BRANCH}/gsd-core"

  if [[ -d "$GSD_CORE_DIR" ]]; then
    log_info "Existing gsd-core runtime found at $GSD_CORE_DIR"
    read -r -p "  Update it? [Y/n] " answer
    answer="${answer:-Y}"
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      log_info "Skipping gsd-core runtime update."
      return 0
    fi
  fi

  # Fast path: copy from an existing Claude Code installation
  if [[ -d "$CLAUDE_CORE_DIR/workflows" ]]; then
    log_info "Found existing Claude Code gsd-core at $CLAUDE_CORE_DIR — copying to $GSD_CORE_DIR"
    mkdir -p "$GSD_CORE_DIR/agents"
    cp -r "$CLAUDE_CORE_DIR/." "$GSD_CORE_DIR/"
    # Claude Code keeps agents at ~/.claude/agents/, not inside gsd-core/agents/.
    # Copy the gsd-* agent definitions across so ~/.bob/gsd-core/agents/ is populated.
    local CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
    if [[ -d "$CLAUDE_AGENTS_DIR" ]]; then
      local agent_copy_count=0
      for f in "$CLAUDE_AGENTS_DIR"/gsd-*.md; do
        [[ -f "$f" ]] || continue
        cp "$f" "$GSD_CORE_DIR/agents/"
        agent_copy_count=$((agent_copy_count + 1))
      done
      log_success "gsd-core runtime copied from Claude Code installation ($agent_copy_count agent definitions)"
    else
      log_warn "~/.claude/agents/ not found — agent definitions will be downloaded from GitHub"
      install_gsd_core_agents "$GSD_CORE_DIR/agents"
    fi
    return 0
  fi

  # Standalone path: download everything directly from GitHub
  log_info "No Claude Code installation found — downloading from GitHub..."
  mkdir -p \
    "$GSD_CORE_DIR/agents" \
    "$GSD_CORE_DIR/workflows" \
    "$GSD_CORE_DIR/references" \
    "$GSD_CORE_DIR/templates"

  install_gsd_core_agents "$GSD_CORE_DIR/agents"
  install_gsd_core_workflows "$GSD_CORE_DIR/workflows" "$GSD_CORE_RAW/workflows"
  install_gsd_core_references "$GSD_CORE_DIR/references" "$GSD_CORE_RAW/references"
  install_gsd_core_templates "$GSD_CORE_DIR/templates" "$GSD_CORE_RAW/templates"
}

install_gsd_core_agents() {
  local dest_dir="$1"
  # Agents live at the repo root (agents/) not inside gsd-core/, so use a
  # different base URL than the other runtime assets.
  local base_url="https://raw.githubusercontent.com/open-gsd/gsd-core/${GSD_CORE_BRANCH}/agents"
  log_info "Downloading gsd-core agent definitions..."

  local agents=(
    gsd-advisor-researcher
    gsd-ai-researcher
    gsd-assumptions-analyzer
    gsd-code-fixer
    gsd-code-reviewer
    gsd-codebase-mapper
    gsd-debug-session-manager
    gsd-debugger
    gsd-doc-classifier
    gsd-doc-synthesizer
    gsd-doc-verifier
    gsd-doc-writer
    gsd-domain-researcher
    gsd-eval-auditor
    gsd-eval-planner
    gsd-executor
    gsd-framework-selector
    gsd-integration-checker
    gsd-intel-updater
    gsd-mempalace-curator
    gsd-nyquist-auditor
    gsd-pattern-mapper
    gsd-phase-researcher
    gsd-plan-checker
    gsd-planner
    gsd-project-researcher
    gsd-research-synthesizer
    gsd-roadmapper
    gsd-security-auditor
    gsd-ui-auditor
    gsd-ui-checker
    gsd-ui-researcher
    gsd-user-profiler
    gsd-verifier
  )

  local installed=0
  local failed=0
  for agent in "${agents[@]}"; do
    local dest="$dest_dir/${agent}.md"
    if curl -fsSL "${base_url}/${agent}.md" -o "$dest" 2>/dev/null; then
      installed=$((installed + 1))
    else
      log_warn "Failed to download agent: ${agent}.md"
      failed=$((failed + 1))
    fi
  done
  log_success "Agent definitions: $installed installed (failed: $failed)"
}

install_gsd_core_workflows() {
  local dest_dir="$1"
  local base_url="$2"
  log_info "Downloading workflows..."

  local workflows=(
    add-backlog
    add-phase
    add-tests
    add-todo
    ai-integration-phase
    analyze-dependencies
    audit-fix
    audit-milestone
    audit-uat
    autonomous
    check-todos
    cleanup
    code-review
    code-review-fix
    complete-milestone
    debug
    diagnose-issues
    discovery-phase
    discuss-phase
    discuss-phase-assumptions
    discuss-phase-power
    do
    docs-update
    edit-phase
    eval-review
    execute-phase
    execute-plan
    explore
    extract-learnings
    fast
    forensics
    graduation
    health
    help
    import
    inbox
    ingest-docs
    insert-phase
    list-phase-assumptions
    list-workspaces
    manager
    map-codebase
    milestone-summary
    mvp-phase
    new-milestone
    new-project
    new-workspace
    next
    node-repair
    note
    pause-work
    plan-milestone-gaps
    plan-phase
    plan-review-convergence
    plant-seed
    pr-branch
    profile-user
    progress
    quick
    reapply-patches
    remove-phase
    remove-workspace
    resume-project
    review
    scan
    secure-phase
    session-report
    settings
    settings-advanced
    settings-integrations
    ship
    sketch
    sketch-wrap-up
    spec-phase
    spike
    spike-wrap-up
    stats
    surface
    sync-skills
    thread
    ui-phase
    ui-review
    ultraplan-phase
    undo
    update
    validate-phase
    verify-work
    workstreams
  )

  local installed=0
  local failed=0
  for wf in "${workflows[@]}"; do
    local dest="$dest_dir/${wf}.md"
    if curl -fsSL "${base_url}/${wf}.md" -o "$dest" 2>/dev/null; then
      installed=$((installed + 1))
    else
      log_warn "Failed to download workflow: ${wf}.md"
      failed=$((failed + 1))
    fi
  done
  log_success "Workflows: $installed installed (failed: $failed)"
}

install_gsd_core_references() {
  local dest_dir="$1"
  local base_url="$2"
  log_info "Downloading references..."

  local references=(
    agent-contracts
    ai-evals
    ai-frameworks
    artifact-types
    autonomous-smart-discuss
    checkpoints
    common-bug-patterns
    context-budget
    continuation-format
    debugger-philosophy
    decimal-phase-calculation
    doc-conflict-engine
    domain-probes
    edge-probe
    execute-mvp-tdd
    executor-examples
    gate-prompts
    gates
    git-integration
    git-planning-commit
    ios-scaffold
    loop-hook-dispatch
    mandatory-initial-read
    model-profile-resolution
    model-profiles
    mvp-concepts
    phase-argument-parsing
    planner-antipatterns
    planner-chunked
    planner-gap-closure
    planner-graphify-auto-update
    planner-guidance
    planner-human-verify-mode
    planner-interface-context
    planner-load-graph-context
    planner-mvp-mode
    planner-reviews
    planner-revision
    planner-source-audit
    planning-config
    prohibition-probe
    project-skills-discovery
    questioning
    research-documentation-lookup
    research-philosophy
    research-verification-protocol
    revision-loop
    scout-codebase
    skeleton-template
    sketch-interactivity
    sketch-theme-system
    sketch-tooling
    sketch-variant-patterns
    spidr-splitting
    tdd
    thinking-models-debug
    thinking-models-execution
    thinking-models-planning
    thinking-models-research
    thinking-models-verification
    thinking-partner
    ui-brand
    universal-anti-patterns
    user-profiling
    user-story-template
    verification-overrides
    verification-patterns
    verify-mvp-mode
    workstream-flag
    worktree-branch-check
    worktree-path-safety
  )

  local installed=0
  local failed=0
  for ref in "${references[@]}"; do
    local dest="$dest_dir/${ref}.md"
    if curl -fsSL "${base_url}/${ref}.md" -o "$dest" 2>/dev/null; then
      installed=$((installed + 1))
    else
      log_warn "Failed to download reference: ${ref}.md"
      failed=$((failed + 1))
    fi
  done
  log_success "References: $installed installed (failed: $failed)"
}

install_gsd_core_templates() {
  local dest_dir="$1"
  local base_url="$2"
  log_info "Downloading templates..."

  local templates=(
    AI-SPEC
    DEBUG
    README
    SECURITY
    UAT
    UI-SPEC
    VALIDATION
    claude-md
    config.json
    context
    continue-here
    copilot-instructions
    debug-subagent-prompt
    dev-preferences
    discovery
    discussion-log
    milestone-archive
    milestone
    phase-prompt
    planner-subagent-prompt
    project
    requirements
    research
    retrospective
    roadmap
    spec
    state
    summary-complex
    summary-minimal
    summary-standard
    summary
    user-profile
    user-setup
    verification-report
  )

  local installed=0
  local failed=0
  for tmpl in "${templates[@]}"; do
    # config.json has no .md extension
    local filename
    if [[ "$tmpl" == "config.json" ]]; then
      filename="config.json"
    else
      filename="${tmpl}.md"
    fi
    local dest="$dest_dir/${filename}"
    if curl -fsSL "${base_url}/${filename}" -o "$dest" 2>/dev/null; then
      installed=$((installed + 1))
    else
      log_warn "Failed to download template: ${filename}"
      failed=$((failed + 1))
    fi
  done
  log_success "Templates: $installed installed (failed: $failed)"
}

# ---------------------------------------------------------------------------
# Verify installation
# ---------------------------------------------------------------------------
verify_installation() {
  log_banner "Verifying installation..."

  local cmd_count
  cmd_count=$(ls "$COMMANDS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')

  local agent_count
  agent_count=$(ls "$AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')

  local core_agent_count
  core_agent_count=$(ls "$BOB_HOME/gsd-core/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')

  local workflow_count
  workflow_count=$(ls "$BOB_HOME/gsd-core/workflows"/*.md 2>/dev/null | wc -l | tr -d ' ')

  local ref_count
  ref_count=$(ls "$BOB_HOME/gsd-core/references"/*.md 2>/dev/null | wc -l | tr -d ' ')

  local tmpl_count
  tmpl_count=$(ls "$BOB_HOME/gsd-core/templates"/* 2>/dev/null | wc -l | tr -d ' ')

  log_success "Commands installed:  $cmd_count/68 in $COMMANDS_DIR"
  log_success "Agents installed:    $agent_count/34 in $AGENTS_DIR"
  log_success "Agent definitions:   $core_agent_count/34 in $BOB_HOME/gsd-core/agents/"
  log_success "Workflows installed: $workflow_count in $BOB_HOME/gsd-core/workflows/"
  log_success "References:          $ref_count in $BOB_HOME/gsd-core/references/"
  log_success "Templates:           $tmpl_count in $BOB_HOME/gsd-core/templates/"

  if [[ "$cmd_count" -lt 60 ]]; then
    log_warn "Expected ~68 commands but found $cmd_count. Some commands may be missing."
  fi
  if [[ "$workflow_count" -lt 50 ]]; then
    log_warn "Expected ~88 workflows but found $workflow_count. Some workflows may be missing."
  fi
}

# ---------------------------------------------------------------------------
# Print next steps
# ---------------------------------------------------------------------------
print_next_steps() {
  echo ""
  echo -e "${BOLD}╔════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}║       GSD for Bob — Installation Done!     ║${NC}"
  echo -e "${BOLD}╚════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "All GSD slash commands are now available in Bob."
  echo ""
  echo -e "${BOLD}Quick start:${NC}"
  echo -e "  ${CYAN}/gsd:progress${NC}    — Check current project status"
  echo -e "  ${CYAN}/gsd:help${NC}        — Show all available commands"
  echo -e "  ${CYAN}/gsd:new-project${NC} — Initialize a new GSD project"
  echo ""
  echo -e "${BOLD}Runtime location:${NC}"
  echo -e "  ${YELLOW}~/.bob/gsd-core/${NC} — workflows, agents, references, templates"
  echo -e "  Installed automatically by this script via one of:"
  echo -e "    1. Copied from ${YELLOW}~/.claude/gsd-core/${NC} (if Claude Code is present)"
  echo -e "    2. Downloaded from ${CYAN}github.com/open-gsd/gsd-core${NC} (standalone)"
  echo ""
  echo -e "${BOLD}Update anytime:${NC}"
  echo -e "  ${CYAN}curl -fsSL $REPO_URL/install.sh | bash${NC}"
  echo ""
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  log_banner "GSD for Bob — Installer"
  echo "Installing GSD (Get Shit Done) slash commands for IBM Bob"
  echo "Source: $REPO_URL"
  echo "Target: $BOB_HOME"
  echo ""

  check_dependencies
  install_commands
  install_agents
  install_gsd_core_runtime
  verify_installation
  print_next_steps
}

main "$@"
