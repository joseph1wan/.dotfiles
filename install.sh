#!/usr/bin/env bash
# Symlinks this repo's files into $HOME. Replaces rcup.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# top-level dotfiles -> ~/.<name>
FILES=(
  aliases
  bash_profile
  gitconfig
  gitignore gitignore_global
  hushlogin
  vimrc
  zprofile zshenv zshrc
)

for f in "${FILES[@]}"; do
  src="$DOTFILES_DIR/$f"
  dest="$HOME/.$f"
  [ -e "$src" ] || continue
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "skip $dest (exists, not a symlink)"
    continue
  fi
  ln -sf "$src" "$dest"
  echo "linked ~/.$f"
done

# directories that map elsewhere
ln -sfn "$DOTFILES_DIR/zsh" "$HOME/.zsh"
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

mkdir -p "$HOME/.claude/skills"
for s in "$DOTFILES_DIR"/claude/skills/*/; do
  name="$(basename "$s")"
  ln -sfn "$s" "$HOME/.claude/skills/$name"
done
ln -sf "$DOTFILES_DIR/claude/statusline.sh" "$HOME/.claude/statusline.sh"

echo "done"
