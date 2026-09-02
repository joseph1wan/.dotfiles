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

- `vimrc`, `vimrc.bundles`, `vimrc.local`, `vimrc.bundles.local` — vim config
- `nvim/` — neovim config, symlinked to `~/.config/nvim`
- `tmux.conf`, `tmux.conf.local` — tmux
- `gitconfig`, `gitconfig.local`, `gitignore`, `gitignore_global` — git
- `zshenv`, `zshrc`, `zshrc.local`, `zprofile` — shell entrypoints
- `zsh/` — zsh functions, completions, and configs loaded by `zshrc`,
  symlinked to `~/.zsh`
- `aliases`, `aliases.local` — shell aliases (`aliases.local` holds
  work-specific aliases/functions, notably `adsk.sh`)
- `adsk.sh` — Autodesk-specific aliases/functions, sourced from
  `aliases.local`
- `awsl-refresh`, `awsl-refresh-daemon.sh` — AWS credential refresh helpers
  (requires VPN)

## Notes

- `*.local` files are machine/work-specific and load after their base
  counterpart.
- `awsl` and related AWS helpers require being on VPN.
