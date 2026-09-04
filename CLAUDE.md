# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal dotfiles, flat repo, no framework (no rcup, no thoughtbot base, no chezmoi). There is no build, lint, or test suite — this is shell/editor config, not application code. "Testing" a change means sourcing the affected file or opening a new shell/nvim instance.

## Commands

- `bash init.sh` — one-shot setup on a new machine: installs Homebrew if missing, `brew bundle`s `Brewfile`, then runs `install.sh`. Pass `--with-adsk` to also pull the private `adsk` submodule and log into the Autodesk npm registry.
- `bash install.sh` — just re-links dotfiles into `$HOME` (no dependency install). Run this after adding/removing a file that needs to be symlinked, or after editing `install.sh` itself. It's idempotent and skips any `$HOME` destination that exists and isn't already a symlink (won't clobber real files).
- `git submodule update --init adsk` — pull the private `adsk` submodule (requires git.autodesk.com access). Everything else works without it.

There's no single command to "apply" a change to the *current* shell — either open a new shell, or `source` the specific file you edited (e.g. `source ~/.zshrc`). Note: `~/.zshrc` intentionally avoids logic that behaves differently on manual re-source vs. fresh shell (see Architecture below), so re-sourcing it is safe to use for testing.

## Architecture

### Symlink model

`install.sh` is the single source of truth for what gets linked where and must stay in sync with the repo layout:
- A flat list of top-level files (`aliases`, `gitconfig`, `zshrc`, etc.) each map `<repo>/<name>` → `~/.<name>`.
- A few directories map to non-dotfile-named destinations: `zsh/` → `~/.zsh`, `nvim/` → `~/.config/nvim`, `starship.toml` → `~/.config/starship.toml`.
- `claude/skills/*` and (if present) `adsk/claude-skills/*` are individually symlinked into `~/.claude/skills/`.
- Adding a new top-level dotfile requires adding it to the `FILES` array in `install.sh`, not just dropping it in the repo root.

### Shell startup chain

Load order for an interactive login zsh: `zshenv` → `zprofile` → `zshrc` (→ `zsh/configs/*` → `zsh/configs/post/*`) → `zshrc.local` (untracked, optional).

- `zshrc` sources `zsh/functions/*` first, then calls `_load_settings ~/.zsh/configs`, which sources every file directly under `configs/` (order: `configs/pre/*`, then everything else, then `configs/post/*`). `post/completion.zsh` runs `compinit` and must stay last since later files may rely on completion being initialized.
- Keybindings live entirely in `zsh/configs/keybindings.zsh`, in one place and in a specific order: base terminal setup (`stty -ixon`) and custom widgets first, then the Escape/Option-key overrides last. **Do not reintroduce `bindkey -v` (vi mode) or any other `bindkey` call after those overrides** — `bindkey -v`/vi-mode resets the whole keymap, silently undoing custom bindings defined earlier in the same file. This was a real bug (vi mode got removed for exactly this reason): any new keybinding customization must be appended after the existing overrides in this file, not scattered into `zshrc` or other config files.
- `zshrc` also sources `${DOTFILES_DIR:-$HOME/.dotfiles}/adsk/zshrc.sh` and `~/.aliases` (which itself conditionally sources `adsk/aliases.sh`) — the adsk submodule is optional and everything degrades gracefully when it's absent.
- `~/.zshenv.local` / `~/.zshrc.local` are honored but untracked — the place for machine-specific secrets that must never be committed. Don't add tracked `.local` sibling files; that pattern was deliberately removed as a leftover from a previous rcup-based setup.

### adsk submodule

`adsk/` is a private submodule (`git@git.autodesk.com:wanj/autodesk-dotfiles.git`) holding Autodesk-specific aliases, AWS credential refresh helpers (`awsl`/`awsl-refresh`, require VPN), diagrams, and work-flavored Claude skills. Treat it as a separate repo: don't assume its contents are readable/available, and don't add Autodesk-specific logic to the main dotfiles files when it could live in `adsk/` instead. `install.sh` and `init.sh` both check for its presence with `[ -d ... ]`/`[ -f ... ]` guards before touching it — follow that pattern for any new adsk integration point.

### Claude Code integration

- `claude/statusline.sh` is symlinked to `~/.claude/statusline.sh`, wired up via `statusLine` in `~/.claude/settings.json` (that settings file itself is not managed by this repo).
- `claude/skills/` holds shared Claude Code skills symlinked into `~/.claude/skills/`; `adsk/claude-skills/` holds Autodesk-private ones symlinked the same way when the submodule is present.
