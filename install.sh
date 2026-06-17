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
GSD_CORE_VERSION="${GSD_CORE_VERSION:-latest}"

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
  for cmd in curl node npm; do
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
# Install gsd-core runtime (workflows, templates, references)
# ---------------------------------------------------------------------------
install_gsd_core_runtime() {
  log_banner "Installing gsd-core runtime into ~/.bob/gsd-core/..."

  local GSD_CORE_DIR="$BOB_HOME/gsd-core"

  if [[ -d "$GSD_CORE_DIR" ]]; then
    log_info "Existing gsd-core runtime found at $GSD_CORE_DIR"
    read -r -p "  Update it? [Y/n] " answer
    answer="${answer:-Y}"
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      log_info "Skipping gsd-core runtime update."
      return 0
    fi
  fi

  # Install gsd-core runtime to ~/.bob using --target to avoid IDE-specific defaults
  log_info "Installing via npm: @opengsd/gsd-core@${GSD_CORE_VERSION}..."
  if command -v npx &>/dev/null; then
    # Primary: --target installs directly to ~/.bob, suppressing gsd-core's own output
    if npx -y "@opengsd/gsd-core@${GSD_CORE_VERSION}" --target "$BOB_HOME" &>/dev/null; then
      log_success "gsd-core runtime installed to $BOB_HOME"
    elif npx -y "@opengsd/gsd-core@${GSD_CORE_VERSION}" --bob &>/dev/null; then
      log_success "gsd-core runtime installed with --bob flag"
    else
      log_warn "npx install failed. Attempting git clone fallback..."
      install_gsd_core_runtime_from_git "$GSD_CORE_DIR"
    fi
  else
    log_warn "npx not found. Attempting git clone fallback..."
    install_gsd_core_runtime_from_git "$GSD_CORE_DIR"
  fi
}

install_gsd_core_runtime_from_git() {
  local dest_dir="$1"
  log_info "Cloning open-gsd/gsd-core (next branch) to $dest_dir..."
  if command -v git &>/dev/null; then
    git clone --depth=1 --branch next \
      "https://github.com/open-gsd/gsd-core.git" \
      "$dest_dir" 2>/dev/null || {
      log_error "git clone failed. Please manually install gsd-core:"
      log_error "  git clone -b next https://github.com/open-gsd/gsd-core.git ~/.bob/gsd-core"
      return 1
    }
    log_success "gsd-core runtime cloned to $dest_dir"
  else
    log_error "git not found. Please manually install gsd-core runtime:"
    log_error "  npx -y @opengsd/gsd-core@latest --target ~/.bob"
    return 1
  fi
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

  log_success "Commands installed: $cmd_count/68 in $COMMANDS_DIR"
  log_success "Agents installed:   $agent_count/34 in $AGENTS_DIR"

  if [[ "$cmd_count" -lt 60 ]]; then
    log_warn "Expected ~68 commands but found $cmd_count. Some commands may be missing."
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
  echo -e "${BOLD}Requirements:${NC}"
  echo -e "  • The gsd-core runtime must be at ${YELLOW}~/.bob/gsd-core/${NC}"
  echo -e "  • Install it with: ${CYAN}npx -y @opengsd/gsd-core@latest --target ~/.bob${NC}"
  echo ""
  echo -e "${BOLD}Update commands anytime:${NC}"
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
