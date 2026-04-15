#!/usr/bin/env bash
# Agent Team Starter Kit — one-liner installer
# Usage: curl -fsSL https://raw.githubusercontent.com/billwhalenmsft/agent-team-starter-kit/main/install.sh | bash

set -e

COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_CYAN="\033[0;36m"
COLOR_RESET="\033[0m"

print_header() {
  echo -e "${COLOR_CYAN}"
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║   🤖  Agent Team Starter Kit             ║"
  echo "  ║   Autonomous AI agent team in a box      ║"
  echo "  ╚══════════════════════════════════════════╝"
  echo -e "${COLOR_RESET}"
}

check_deps() {
  local missing=()
  command -v python3 &>/dev/null || missing+=("python3")
  command -v git &>/dev/null || missing+=("git")
  command -v gh &>/dev/null || missing+=("gh (GitHub CLI)")
  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${COLOR_YELLOW}Missing dependencies: ${missing[*]}${COLOR_RESET}"
    echo "Install them first, then re-run this script."
    echo ""
    echo "  brew install python git gh   # Mac"
    echo "  sudo apt install python3 git && gh installation: https://cli.github.com"
    exit 1
  fi
}

print_header
check_deps

echo -e "${COLOR_GREEN}▶ Cloning Agent Team Starter Kit...${COLOR_RESET}"
DEST="./agent-team-starter-kit"
if [ -d "$DEST" ]; then
  echo "  Directory $DEST already exists — pulling latest..."
  cd "$DEST" && git pull --quiet && cd ..
else
  git clone --quiet https://github.com/billwhalenmsft/agent-team-starter-kit.git "$DEST"
fi

echo -e "${COLOR_GREEN}▶ Checking Python version...${COLOR_RESET}"
PYVER=$(python3 -c 'import sys; print(sys.version_info.major * 10 + sys.version_info.minor)')
if [ "$PYVER" -lt 39 ]; then
  echo -e "${COLOR_YELLOW}⚠ Python 3.9+ recommended (you have $(python3 --version))${COLOR_RESET}"
fi

echo ""
echo -e "${COLOR_GREEN}✅ Ready! Running setup...${COLOR_RESET}"
echo ""
cd "$DEST"
python3 setup_agent_team.py
