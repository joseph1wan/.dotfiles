let g:python3_host_prog = '/opt/homebrew/bin/python3'

set encoding=utf-8

" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set termguicolors " make our colors pretty
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set modelines=0   " Disable modelines as a security precaution
set nomodeline

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile
    \ zshenv.local,zlogin.local,zlogout.local,zprofile.local,
    \*/zsh/configs/*
    \ set filetype=sh
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use ripgrep https://github.com/BurntSushi/ripgrep
if executable('rg')
  " Use Rg over Grep
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
elseif executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Set tags for vim-fugitive
set tags^=.git/tags

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Settings
set ignorecase
set scrolloff=5
set relativenumber
highlight Pmenu ctermbg=gray guibg=gray
set colorcolumn=0

" Key mappings
ino jk <esc>
cno jk <c-c>
noremap <A-h> <Left>
noremap <A-j> <Down>
noremap <C-k> <Up>
noremap <C-l> <Right>
vno v <esc>
nmap <Leader>- :split<Cr>
nmap <Leader>\ :vsplit<Cr>

" Simple editing
nmap <Leader>o mao<Esc>'a
nmap <Leader>O maO<Esc>'a
nmap <Leader>D mq$x`q
nmap <Leader>dt d
nmap <Leader>ll mkgg=G'k
noremap <Leader>i mki <Esc>
nmap <Leader>H ^
nmap <Leader>L $
nmap Y yy

" File manipulation
nmap <Leader>w :wa<Cr>
nmap <Leader>q :q<Cr>
nmap <Leader>so :so $MYVIMRC<CR>
nmap <Leader>eso :vsplit $MYVIMRC<Esc>

nmap <Leader>} ysiW}i#<Esc>
nmap <Leader>d) ds)i <Esc>
nmap <Leader># ysiW}i#<Esc>
nmap <Leader># viw<Leader>#
vmap <Leader># S}i#<Esc>
nmap <Leader>: i:<Esc>ysiW]i
nmap <Leader>" viw<Leader>"
vmap <Leader>" S"
nmap <Leader>;: ds]xf=Xr:
nmap <Leader>:> ysiw'f:cw =><Esc>
nmap <Leader>': ds'elcf>:<Esc>
nmap <Leader>": ds'elcf>:<Esc>
nmap <Leader>` ysiw`

" Replace word with paste
nmap <Leader>vwp viwp

" Use macro
nmap <Leader>1 @q
nmap <Leader>2 @w
nmap <Leader>3 @e
nmap <Leader>4 @r
nmap <Leader>5 @t
nmap <Leader>6 @y
nmap <Leader>7 @u
nmap <Leader>8 <Leader>Hf{DJd2f:vUf,cl.new(jklx/},<Enter>C),jk

" Copy and paste
nmap <Leader>cc ggvG cc
nmap <Leader>vv ggdG"+p<Esc>
nmap <Leader>ya ggyG
vnoremap <Leader>cc :%w !pbcopy<cr><cr>
" noremap <Leader>vv o<C-r>*<Esc>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

set undofile
set undodir=~/.vim/undodir
set formatoptions-=tc

" html and Jenkinsfile filetype settings
autocmd FileType html,Jenkinsfile setlocal cc=
autocmd FileType sh setlocal formatoptions-=tc cc=

autocmd BufRead,BufNewFile *.html setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.envrc setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.json setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.txt setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.md setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.mdx setlocal nowrap cc= formatoptions-=tc textwidth=0

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

silent! colorscheme catppuccin
