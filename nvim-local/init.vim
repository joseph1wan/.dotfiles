set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

lua require('plugins')
lua require('mason').setup()
lua require("mason-lspconfig").setup()
lua require('lspconfig-setup')
lua require('prettier-config')

source ~/.vimrc
