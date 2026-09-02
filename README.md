# dotfiles

Personal dotfiles. Flat repo, no framework (no rcup, no thoughtbot base).

## Install

```
bash init.sh
```

Installs dependencies via Homebrew (`Brewfile`) and symlinks everything into
`$HOME` via `install.sh`.

To just re-link without reinstalling dependencies:

```
bash install.sh
```

## Layout

- `vimrc` — vim/neovim settings, sourced by `nvim/init.vim`
- `nvim/` — neovim config, symlinked to `~/.config/nvim`
- `gitconfig`, `gitignore`, `gitignore_global` — git
- `zshenv`, `zshrc`, `zprofile` — shell entrypoints
- `zsh/` — zsh functions, completions, and configs loaded by `zshrc`,
  symlinked to `~/.zsh`
- `aliases` — shell aliases, including work-specific aliases/functions
- `adsk.sh` — Autodesk-specific aliases/functions, sourced from `aliases`
- `awsl-refresh`, `awsl-refresh-daemon.sh` — AWS credential refresh helpers
  (requires VPN)
- `claude/statusline.sh` — Claude Code statusline, symlinked to
  `~/.claude/statusline.sh` (wired up via `statusLine` in
  `~/.claude/settings.json`, which is not managed by this repo)

## Notes

- `zshenv` and `zshrc` still honor an optional untracked `~/.zshenv.local`
  / `~/.zshrc.local` for machine-specific secrets that shouldn't be
  committed at all — these are not part of this repo and not symlinked
  by `install.sh`. Everything else that used to be split into
  `foo`/`foo.local` pairs (an artifact of a previous rcup-based setup,
  where `foo.local` was tracked and symlinked just like `foo`) has been
  merged, since this whole repo is already private.
- `awsl` and related AWS helpers require being on VPN.
