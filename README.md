Personal collection of `dotfiles.` Builds on top of [thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles).

Requires manually symlinking `nvim-local`:
```bash
rcup # nvim-local gets symlinked to ~/.nvim-local
rm -rf ~/.config/nvim
ln -s ~/.nvim-local ~/.config/nvim
```

Dependencies:
```
brew install nvim
brew install the_silver_searcher
brew install rbenv
brew install pyenv
brew install antigen
brew install asdf
brew install tmux
brew install prettier
brew install direnv
```

Install `tpm` and plugins:
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Prefix + I to install plugins
```
