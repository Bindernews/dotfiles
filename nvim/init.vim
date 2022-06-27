
lua << EOF
-- Load plugins
require("plugins")
-- Load custom :Trust command
require("trust")

-- Using map leader allows us to use extra key combinations
local leader=","
vim.g.mapleader = leader

-- Init nvim tree with default settings
require("nvim-tree").setup {
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = leader.."o", action = "tabnew" },
        -- Swap s and S actions
        { key = "s", action = "search_node" },
        { key = "S", action = "system_open" },
      }
    }
  }
}
EOF

" Enable mouse usage (all modes)
set mouse=a

""""""""
" Misc Settings
""""""""
" Use 4 spaces and tabs
set tabstop=4 shiftwidth=4 expandtab
" Timeout for key sequences
set tm=500
" Show hybrid line numberd
set number relativenumber
" Show the row and column in the statusbar
set ruler
" Show matching brackets.
set showmatch 
" Don't redraw while executing macros (improves performance)
" TODO may not be necessary for nvim
set lazyredraw
" Set column limit
set colorcolumn=100

" Disable relative line numbers for unfocused buffers
" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Shortcut for clearing the current highlight
map <leader>l :nohl<CR>

" Map Shift-Tab to unindent
inoremap <S-Tab> <C-D>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <<<ESC>

" Map Ctrl+a to select all
map <C-a> <ESC>ggVG<CR>

" Mappings for tree view
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Needed for folder icons?
highlight NvimTreeFolderIcon guibg=blue
" Use better color scheme
colorscheme nordfox

" vim: set ts=2 sw=2
