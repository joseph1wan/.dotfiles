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
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

mkdir -p "$HOME/.claude/skills"
# prune symlinks whose source is gone (renamed or removed skills)
for l in "$HOME"/.claude/skills/*; do
  if [ -L "$l" ] && [ ! -e "$l" ]; then
    rm -f "$l"
    echo "pruned stale skill symlink: $(basename "$l")"
  fi
done
for s in "$DOTFILES_DIR"/claude/skills/*/; do
  name="$(basename "$s")"
  ln -sfn "$s" "$HOME/.claude/skills/$name"
done
ln -sf "$DOTFILES_DIR/claude/statusline.sh" "$HOME/.claude/statusline.sh"

if [ -d "$DOTFILES_DIR/adsk/claude-skills" ]; then
  for s in "$DOTFILES_DIR"/adsk/claude-skills/*/; do
    name="$(basename "$s")"
    ln -sfn "$s" "$HOME/.claude/skills/$name"
  done
fi

if [ -f "$DOTFILES_DIR/adsk/claude/CLAUDE.md" ]; then
  ln -sf "$DOTFILES_DIR/adsk/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
fi

if [ -f "$DOTFILES_DIR/adsk/npmrc.template" ] && [ ! -f "$HOME/.npmrc" ]; then
  cp "$DOTFILES_DIR/adsk/npmrc.template" "$HOME/.npmrc"
  echo "wrote ~/.npmrc from adsk template (run npm login to add auth)"
fi

if [ -f "$DOTFILES_DIR/adsk/sshconfig" ]; then
  mkdir -p "$HOME/.ssh"
  if [ -e "$HOME/.ssh/adsk_config" ] && [ ! -L "$HOME/.ssh/adsk_config" ]; then
    echo "skip ~/.ssh/adsk_config (exists, not a symlink)"
  else
    ln -sf "$DOTFILES_DIR/adsk/sshconfig" "$HOME/.ssh/adsk_config"
    echo "linked ~/.ssh/adsk_config"
  fi
  include_line="Include ~/.ssh/adsk_config"
  touch "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  if ! grep -qxF "$include_line" "$HOME/.ssh/config"; then
    # Include directives must precede any Host block they should take priority
    # over, so prepend rather than append.
    printf '%s\n%s\n' "$include_line" "$(cat "$HOME/.ssh/config")" > "$HOME/.ssh/config.tmp"
    mv "$HOME/.ssh/config.tmp" "$HOME/.ssh/config"
    echo "added Include for adsk ssh config to ~/.ssh/config"
  fi
fi

if [ -f "$DOTFILES_DIR/adsk/known_hosts" ]; then
  mkdir -p "$HOME/.ssh"
  touch "$HOME/.ssh/known_hosts"
  comm -23 <(sort "$DOTFILES_DIR/adsk/known_hosts") <(sort "$HOME/.ssh/known_hosts") >> "$HOME/.ssh/known_hosts"
  echo "merged adsk known_hosts entries into ~/.ssh/known_hosts"
fi

echo "done"
