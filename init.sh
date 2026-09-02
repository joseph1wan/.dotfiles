#!/usr/bin/env bash
# One-shot setup: installs deps, symlinks dotfiles.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

if ! command -v brew >/dev/null; then
  echo "installing homebrew..."
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

echo "symlinking dotfiles..."
bash "$DOTFILES_DIR/install.sh"

echo "done. open a new shell to pick up changes."
