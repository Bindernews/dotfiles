
" Inspiration sources:
"   https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
"   https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim

let mapleader = "," " Using map leader allows us to use extra key combinations
set nocompatible    " Give some nice vim-only features and required for Vundle
filetype plugin indent on   " Use plugin indents

" Get the dotfiles directory, even through a symlink (https://stackoverflow.com/a/18734557)
let $DOTFILES = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" Make vim load plugins from dotfiles
set packpath+=$DOTFILES

""""""""""""""
" ==> Turn on and confgigure the Wild Menu
""""""""""""""

set wildmenu        " Turn on the Wild menu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
" Ignore version control and .DS_Store directories
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Miscellaneous settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set cmdheight=2     " Change the height of the command bar
set backspace=indent,eol,start  " Make backspace work intelligently
set autoread        " auto-read when a file is changed externally
set number          " Show line numbers
set tabstop=4		" We use 4 spaces here
set shiftwidth=4	" We use 4 spaces here
set expandtab		" Use spaces instead of tabs
set smarttab        " Be smart when using tabs
set autoindent      " Automatically indent when going to a new line
set smartindent     " Smart indent
set showcmd         " Show (partial) command in status line.
set showmatch		" Show matching brackets.

" Make search behave nicely
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hlsearch        " highlight the search results

" Don't redraw while executing macros (improves performance)
set lazyredraw

" Get rid of annoying error stuff
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable syntax highlighting
syntax enable

set autowrite   " Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" Give our buffers more space
if &history < 1000
    set history=1000
endif
if &tabpagemax < 50
    set tabpagemax=50
endif
" Don't save our options in the sessions
set sessionoptions-=options

" Map Shift-Tab to unindent
inoremap <S-Tab> <C-D>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <<<ESC>

" Map Ctrl+a to select all
map <C-a> <ESC>ggVG<CR>

" Shortcut for clearing the current highlight
map <leader>l :nohl<CR>

" Make saving and loading sessions easy
map <F2> <ESC>:mksession! .vim_session<CR>
map <F3> <ESC>:source .vim_session<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows, and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Smart window navigation
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Open a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<CR>/

" Map ,<number> takes you to that number tab
noremap <unique> <leader>1 1gt
noremap <unique> <leader>2 2gt
noremap <unique> <leader>3 3gt
noremap <unique> <leader>4 4gt
noremap <unique> <leader>5 5gt
noremap <unique> <leader>6 6gt
noremap <unique> <leader>7 7gt
noremap <unique> <leader>8 8gt
noremap <unique> <leader>9 9gt
noremap <unique> <leader>0 10gt

" Map ,w and ,e take you to the previous and next tabs, respectively
map <leader>w :tabp<CR>
map <leader>e :tabn<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""
" => Load directory .vimrc. ONLY DO THIS IF YOU TRUST THE LOCAL VIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""
if $VIM_LOCAL !=? ""
    source .vimrc
endif


