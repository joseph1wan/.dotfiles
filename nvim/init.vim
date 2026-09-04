set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

lua require('plugins')


source ~/.vimrc

" Auto-create parent directory on save if it doesn't exist
augroup AutoMkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand('<afile>:p:h'), 'p')
augroup END
