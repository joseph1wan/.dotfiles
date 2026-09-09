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
- `aliases` — shell aliases
- `adsk/` — private git.autodesk.com submodule with Autodesk-specific
  aliases, AWS credential refresh helpers (`awsl-refresh`, requires VPN),
  diagrams, and work-flavored Claude skills. Optional — everything else
  works without it. After cloning, run `git submodule update --init` to
  pull it (requires git.autodesk.com access)
- `claude/statusline.sh` — Claude Code statusline, symlinked to
  `~/.claude/statusline.sh` (wired up via `statusLine` in
  `~/.claude/settings.json`, which is not managed by this repo)

## Notes

- If `adsk/known_hosts` is present, `install.sh` merges its entries into
  `~/.ssh/known_hosts`, skipping lines already present there — safe to
  re-run without piling up duplicates.
- `zshenv` and `zshrc` still honor an optional untracked `~/.zshenv.local`
  / `~/.zshrc.local` for machine-specific secrets that shouldn't be
  committed at all — these are not part of this repo and not symlinked
  by `install.sh`. Everything else that used to be split into
  `foo`/`foo.local` pairs (an artifact of a previous rcup-based setup,
  where `foo.local` was tracked and symlinked just like `foo`) has been
  merged, since this whole repo is already private.
- `awsl` and related AWS helpers require being on VPN.
