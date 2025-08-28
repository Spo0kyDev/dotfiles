" === Core ===
set nocompatible
syntax on
filetype plugin indent on

set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cindent
set nowrap
if has('termguicolors')
  set termguicolors
endif
set background=dark
" Load gruvbox if present (avoids error on machines without it)
if filereadable(expand("~/.vim/colors/gruvbox.vim"))
  colorscheme gruvbox
endif
set nocursorline

" Command-line completion: show all matches on <Tab>
set wildmenu
set wildmode=longest:list,full

" === Startup Quote ===
autocmd VimEnter * echom "The truth is out there."

" === Back-tab (Shift+Tab) ===
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <gv

" === Auto-pairs for () {} [] '' "" ===
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ' ''<Left>
inoremap " ""<Left>

" Enter inside { } creates an indented block
inoremap {<CR> {<CR>}<Esc>O

" === Block comments: /** + Enter -> Javadoc/Doxygen style ===
inoremap <expr> <CR> getline('.') =~ '^\s*/\*\*$' ? '<CR> * <CR>*/<Esc>kA' : '<CR>'

" Also quick insert of /*  */ with Ctrl-/ (terminals often send Ctrl-_)
inoremap <C-_> /*  */<Left><Left><Left>
inoremap <C-/> /*  */<Left><Left><Left>

" === Compile & run C with F5 (buffer-local) ===
augroup CBuildRun
  autocmd!
  autocmd FileType c nnoremap <buffer> <F5> :w<CR>:!gcc % -o %< && ./%<<CR>
augroup END

" === Quickfix navigation ===
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap <leader>n :nohlsearch<CR>

