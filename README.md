Personal collection of `dotfiles.` Builds on top of [thoughtbot's dotfiles](https://github.com/thoughtbot/dotfiles).

Requires manually symlinking `nvim-local`:
1. Run `rcup` to symlink `nvim-local` to `~/.nvim-local`
2. `rm -rf .config/nvim`
3. `ln -s ~/.nvim-local .config/nvim`
