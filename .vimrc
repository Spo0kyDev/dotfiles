" ============================================================================
"  .vimrc - C-focused, portable, quickfix-first, gruvbox + rainbow
" ============================================================================

" ============================================================================
" === Core Startup and File Behavior ===
" ============================================================================
set nocompatible
syntax on
filetype plugin indent on

" ============================================================================
" === Cursor and Line Display ===
" ============================================================================
set number
set relativenumber
set cursorline
set scrolloff=8
set nowrap

" ============================================================================
" === Search ===
" ============================================================================
set hlsearch
set incsearch
set ignorecase
set smartcase
nnoremap <leader>n :nohlsearch<CR>

" ============================================================================
" === Tabs, Indentation, and Formatting ===
" ============================================================================
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set cindent
set backspace=indent,eol,start
set hidden

" ============================================================================
" === Better C + Doxygen Highlighting ===
" ============================================================================
let g:c_extra_syntax = 1
let g:c_syntax_for_h = 1
let c_gnu = 1
let c_comment_strings = 1
let c_space_errors = 1
let g:load_doxygen_syntax = 1

" ============================================================================
" === Clipboard ===
" ============================================================================
" Uncomment if your Vim supports system clipboard.
" set clipboard=unnamedplus

" ============================================================================
" === Colors and Theme ===
" ============================================================================
if has('termguicolors')
  set termguicolors
endif

set background=dark

" Works whether gruvbox is installed by plugin manager or copied into ~/.vim/colors/.
try
  colorscheme gruvbox
catch
endtry

" ============================================================================
" === Command-Line Completion and Interface Aids ===
" ============================================================================
set wildmenu
set wildmode=longest:list,full
set ruler

" ============================================================================
" === Writing Guides and Layout Helpers ===
" ============================================================================
set textwidth=80
set colorcolumn=80

" ============================================================================
" === Status Line ===
" ============================================================================
set statusline=%f\ %y\ %m\ %r\ %=Size:%{getfsize(expand('%'))}\ bytes
set laststatus=2

" ============================================================================
" === Startup Message ===
" ============================================================================
autocmd VimEnter * echom "The truth is out there."

" ============================================================================
" === Indentation Shortcuts ===
" ============================================================================
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <gv

" ============================================================================
" === Auto-Pairs and Insert Helpers ===
" ============================================================================
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap {<CR> {<CR>}<Esc>O

" ============================================================================
" === Comment Writing Helpers ===
" ============================================================================
" If the current line is exactly /** and you press Enter,
" expand it into a Doxygen/Javadoc-style comment block.
inoremap <expr> <CR> getline('.') =~ '^\s*/\*\*$' ? '<CR> * <CR>*/<Esc>kA' : '<CR>'

" Insert a block comment skeleton with Ctrl-_ or Ctrl-/.
inoremap <C-_> /*  */<Left><Left><Left>
inoremap <C-/> /*  */<Left><Left><Left>

" ============================================================================
" === Plugin-Specific Settings ===
" ============================================================================
" Enable rainbow parentheses/brackets if the plugin is installed.
let g:rainbow_active = 1

" ============================================================================
" === Build Settings for C ===
" ============================================================================
" Default: C11 with AddressSanitizer for debugging.
set makeprg=gcc\ -std=c11\ -Wall\ -Wextra\ -g\ -O0\ -fsanitize=address\ -fno-omit-frame-pointer\ %\ -o\ %<

" Uncomment this for strict school/C89-style builds instead.
" set makeprg=gcc\ -std=gnu89\ -Wall\ -Wextra\ -pedantic\ %\ -o\ %:r.out

set errorformat=%f:%l:%c:\ %m

" ============================================================================
" === C File Build and Run Shortcuts ===
" ============================================================================
augroup CBuildRun
  autocmd!

  " F5 = save file, compile it, open quickfix window if there are errors.
  autocmd FileType c nnoremap <buffer> <F5> :w<CR>:silent make<CR>:cwindow<CR>:redraw!<CR>

  " F6 = save file, compile it, clear terminal output, and run the program.
  autocmd FileType c nnoremap <buffer> <F6> :w<CR>:silent make<CR>:!clear; ./%:r<CR>
augroup END

" ============================================================================
" === Quickfix Shortcuts ===
" ============================================================================
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap <leader>q :cclose<CR>

" Legacy alternatives from the old config.
nnoremap <F9> :w<CR>:make<CR>:copen<CR>
nnoremap <F8> :!./%:r.out<CR>
