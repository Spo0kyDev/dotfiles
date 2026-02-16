" ============================================================================
"  .vimrc - C-focused, portable, quickfix-first (gnu89), gruvbox + rainbow
" ============================================================================

" --- Core ---
set nocompatible
syntax on
filetype plugin indent on

" --- UI ---
set number
set relativenumber
set cursorline
set scrolloff=8
set nowrap

" --- Search ---
set hlsearch
set incsearch
set ignorecase
set smartcase
nnoremap <leader>n :nohlsearch<CR>

" --- Indentation / whitespace (C-friendly) ---
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set cindent
set backspace=indent,eol,start
set hidden

" --- Better C + Doxygen highlighting ---
let g:c_extra_syntax = 1
let g:c_syntax_for_h = 1
let c_gnu = 1
let c_comment_strings = 1
let c_space_errors = 1
let g:load_doxygen_syntax = 1

" --- Auto-pairs (simple, no plugin) ---
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap {<CR> {<CR>}<Esc>O

" Doxygen block: if line is only '/**', Enter expands it
inoremap <expr> <CR> getline('.') =~ '^\s*/\*\*$' ? '<CR> * <CR>*/<Esc>kA' : '<CR>'

" --- Quickfix-based build/run (match school: gnu89/C89 expectations) ---
" :make uses makeprg, populates quickfix list.
set makeprg=gcc\ -std=gnu89\ -Wall\ -Wextra\ -pedantic\ %\ -o\ %:r.out

nnoremap <F9> :w<CR>:make<CR>:copen<CR>
nnoremap <F8> :!./%:r.out<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

" --- Colors: Gruvbox if installed ---
if has('termguicolors')
  set termguicolors
endif
set background=dark

" Works whether installed via plugin manager or copied into ~/.vim/colors/
try
  colorscheme gruvbox
catch
endtry

" --- Rainbow parentheses if plugin is installed ---
let g:rainbow_active = 1

" --- Startup message (optional) ---
autocmd VimEnter * echom "The truth is out there."
