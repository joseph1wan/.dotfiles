#!/usr/bin/env bash
# One-shot setup: installs deps, symlinks dotfiles.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WITH_ADSK=0
for arg in "$@"; do
  case "$arg" in
    --with-adsk) WITH_ADSK=1 ;;
  esac
done

if ! command -v brew >/dev/null; then
  echo "installing homebrew..."
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew tap hashicorp/tap
brew trust hashicorp/tap

echo "installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

if [ "$WITH_ADSK" -eq 1 ]; then
  echo "fetching adsk submodule..."
  git -C "$DOTFILES_DIR" submodule update --init adsk || echo "warn: adsk submodule fetch failed (needs git.autodesk.com access)"

  echo "installing go..."
  brew install go || echo "warn: go install skipped"

  echo "installing drawio..."
  brew install --cask drawio || echo "warn: drawio install skipped"

  if [ -f "$DOTFILES_DIR/adsk/npmrc.template" ] && [ ! -f "$HOME/.npmrc" ]; then
    cp "$DOTFILES_DIR/adsk/npmrc.template" "$HOME/.npmrc"
  fi

  echo "logging into Autodesk npm registry..."
  if ! npm login; then
    echo "npm login failed. Run 'npm login' manually, then re-run ./init.sh --with-adsk."
    exit 1
  fi
fi

npm install -g serverless 2>/dev/null || echo "warn: serverless install skipped"

npm install -g codebase-memory-mcp 2>/dev/null || echo "warn: codebase-memory-mcp install skipped"

if command -v claude >/dev/null; then
  claude mcp add --scope user codebase-memory-mcp -- codebase-memory-mcp 2>/dev/null || echo "warn: codebase-memory-mcp already registered or claude mcp add failed"

  claude mcp add --scope user --transport http slack https://mcp.slack.com/mcp 2>/dev/null || echo "warn: slack mcp already registered or claude mcp add failed"

  claude mcp add --scope user --transport http atlassian https://mcp.atlassian.com/v1/mcp 2>/dev/null || echo "warn: atlassian mcp already registered or claude mcp add failed"

  if [ "$WITH_ADSK" -eq 1 ]; then
    if [ -z "${JENKINS_USERNAME:-}" ]; then
      read -p "Jenkins username for c072: " JENKINS_USERNAME
    fi
    if [ -z "${JENKINS_API_TOKEN:-}" ]; then
      read -sp "Jenkins API token for c072: " JENKINS_API_TOKEN
      echo
    fi
    claude mcp add --scope user --transport http jenkins-c072-mcp https://jenkins.mcp.cloudos.adskeng.net/mcp \
      --header "X-Jenkins-URL: https://c072.cloudbees-ci.autodesk.com/" \
      --header "X-Jenkins-Username: $JENKINS_USERNAME" \
      --header "X-Jenkins-Password: $JENKINS_API_TOKEN" \
      2>/dev/null || echo "warn: jenkins-c072-mcp already registered or claude mcp add failed"
  fi
fi

echo "symlinking dotfiles..."
bash "$DOTFILES_DIR/install.sh"

echo "done. open a new shell to pick up changes."
