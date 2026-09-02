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

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
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

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    autocmd VimEnter *
      \ set updatetime=1000 |
      \ let g:ale_lint_on_text_changed = 0
    autocmd CursorHold * call ale#Queue(0)
    autocmd CursorHoldI * call ale#Queue(0)
    autocmd InsertEnter * call ale#Queue(0)
    autocmd InsertLeave * call ale#Queue(0)
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
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

  " Use rg in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

  nnoremap \ :Rg<SPACE>
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
elseif executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in fzf for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  nnoremap \ :Ag<SPACE>
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

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

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

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Map Ctrl + p to open fuzzy find (FZF)
nnoremap <c-p> :Files<cr>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Use Catpuccin Latte as our default color scheme
colorscheme catppuccin_latte

" Settings
set ignorecase
set scrolloff=5
set relativenumber
set tags^=./.git/tags
highlight Pmenu ctermbg=gray guibg=gray
let g:ale_set_highlights = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
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

" Alternate files and rspec files
nmap <Leader>r :A<Cr>
nmap <Leader>rf :Rfactory<Cr>
nmap <Leader>R :vsplit<Cr>:A<Cr>
nmap <Leader>A :vsplit<Cr>:Alternate<CR>

nmap <Leader>n :NERDTreeToggle<Cr>

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

" Copilot Chat
nmap <Leader>p :CopilotChatToggle<Cr>


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

let g:rspec_command = "VtrSendCommandToRunner! be rspec {spec} --format doc"
map <Leader>t ::wa<CR>:call RunCurrentSpecFile()<CR>
map <Leader>s :wa<CR>:call RunNearestSpec()<CR>
map <Leader>l :wa<CR>:call RunLastSpec()<CR>
map <Leader>a :wa<CR>:call RunAllSpecs()<CR>
map <Leader>f :wa<CR>:VtrSendCommandToRunner be rspec --format=doc --only-fail<CR>

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

" VTR commands
nnoremap <leader>v- :VtrOpenRunner { "orientation": "v" }<cr>
noremap <leader>v\ :VtrOpenRunner { "orientation": "h" }<cr>
nnoremap <leader>vk :VtrKillRunner<cr>
nnoremap <leader>va :VtrAttachToPane<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
nnoremap <Leader>sl :VtrSendLinesToRunner<cr>
vno  <Leader>sl :VtrSendLinesToRunner<cr>
nnoremap <leader>vs :VtrSendCommandToRunner<space>
map <Leader>r :wa<CR>:VtrSendCommandToRunner !! --only-fail<CR>
map <Leader>v2 :VtrAttachToPane 2<CR>
map <Leader>v3 :VtrAttachToPane 3<CR>

" Run a given vim command on the results of alt from a given path.
" See usage below.
function! AltCommand(path, vim_command)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction

" Find the alternate file for the current path and open it
nnoremap <leader>. :w<cr>:call AltCommand(expand('%'),':e')<cr>

set undofile
set undodir=~/.vim/undodir
set formatoptions-=tc

let g:ruby_indent_access_modifier_style="indent"
let g:vimrubocop_config = getcwd() . '/rubocop.yml'

" erb and html filetype settings
autocmd FileType eruby,html,Jenkinsfile setlocal cc=
autocmd FileType sh setlocal formatoptions-=tc cc=

autocmd BufRead,BufNewFile *.html setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.envrc setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.json setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.txt setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.md setlocal nowrap cc= formatoptions-=tc textwidth=0
autocmd BufRead,BufNewFile *.mdx setlocal nowrap cc= formatoptions-=tc textwidth=0

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

let g:AlternateExtensionMappings = [{'.rb': '.html.erb'}, {'.html.erb': '.rb'}]
let g:mkdp_echo_preview_url = 1
autocmd Filetype json
  \ let g:indentLine_setConceal = 0 |
  \ let g:vim_json_syntax_conceal = 0

silent! colorscheme catppuccin
