Personal collection of `dotfiles.` Builds on top of [thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles).

Requires manually symlinking `nvim-local`:
```
rcup # nvim-local gets symlinked to ~/.nvim-local
rm -rf ~/.config/nvim
ln -s ~/.nvim-local ~/.config/nvim
```
