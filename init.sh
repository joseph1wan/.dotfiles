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

npm install -g serverless 2>/dev/null || echo "warn: serverless install skipped"

npm install -g codebase-memory-mcp 2>/dev/null || echo "warn: codebase-memory-mcp install skipped"
if command -v claude >/dev/null; then
  claude mcp add --scope user codebase-memory-mcp -- codebase-memory-mcp 2>/dev/null || echo "warn: codebase-memory-mcp already registered or claude mcp add failed"
fi

if [ "$WITH_ADSK" -eq 1 ]; then
  echo "fetching adsk submodule..."
  git -C "$DOTFILES_DIR" submodule update --init adsk || echo "warn: adsk submodule fetch failed (needs git.autodesk.com access)"

  echo "logging into Autodesk npm registry..."
  npm login --registry https://npm.autodesk.com/artifactory/api/npm/npm-remote/ || echo "warn: npm login failed/skipped"
fi

echo "symlinking dotfiles..."
bash "$DOTFILES_DIR/install.sh"

echo "done. open a new shell to pick up changes."
