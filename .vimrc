" ============================================================================
<<<<<<< Updated upstream
"  .vimrc - C-focused, portable, quickfix-first (gnu89), gruvbox + rainbow
" ============================================================================

" --- Core ---
set nocompatible
=======
" === Core Startup and File Behavior ===
" ============================================================================
"
" Enable syntax highlighting.
>>>>>>> Stashed changes
syntax on

" Enable filetype detection, filetype-specific plugins, and indentation rules.
filetype plugin indent on

<<<<<<< Updated upstream
" --- UI ---
=======

" ============================================================================
" === Cursor and Line Display ===
" ============================================================================
"
" Highlight the current line to make the cursor easier to track.
set cursorline

" Show absolute line number on the current line.
>>>>>>> Stashed changes
set number

" Show relative line numbers on other lines for easier movement with j/k or counts.
set relativenumber
<<<<<<< Updated upstream
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
=======


" ============================================================================
" === Tabs, Indentation, and Formatting ===
" ============================================================================
"
" Display a tab character as 4 spaces wide.
>>>>>>> Stashed changes
set tabstop=4

" Use 4 spaces for each step of autoindent.
set shiftwidth=4

" Convert typed tabs into spaces.
" Useful for C and for keeping indentation consistent.
set expandtab
<<<<<<< Updated upstream
set autoindent
=======

" Automatically indent new lines based on the previous line.
>>>>>>> Stashed changes
set smartindent

" Use C-style indentation rules.
set cindent
<<<<<<< Updated upstream
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
=======

" Do not wrap long lines visually.
set nowrap


" ============================================================================
" === Clipboard ===
" ============================================================================
"
" Use the system clipboard.
" This is currently left commented out, matching your original file.
" Uncomment this if your Vim supports it and you want copy/paste with the OS.
" set clipboard=unnamedplus


" ============================================================================
" === Colors and Theme ===
" ============================================================================
"
" Enable true color support if the terminal supports it.
if has('termguicolors')
  set termguicolors
endif

" Use a dark background theme.
set background=dark

" Load the gruvbox colorscheme only if it exists.
" This avoids errors on systems where gruvbox is not installed.
if filereadable(expand("~/.vim/colors/gruvbox.vim"))
  colorscheme gruvbox
endif


" ============================================================================
" === Command-Line Completion and Interface Aids ===
" ============================================================================
"
" Enable enhanced command-line completion menu.
set wildmenu

" Complete to the longest common match first, then show full list.
set wildmode=longest:list,full

" Show the cursor position and other useful info in the command area.
set ruler


" ============================================================================
" === Writing Guides and Layout Helpers ===
" ============================================================================
"
" Set the preferred text width to 80 characters.
set textwidth=80

" Show a visual column marker at column 80.
" Helpful for code style and readability.
set colorcolumn=80


" ============================================================================
" === Status Line ===
" ============================================================================
"
" Customize the status line to show:
" %f = filename
" %y = filetype
" %m = modified flag
" %r = readonly flag
" %= = split left/right sections
" getfsize(...) = current file size in bytes
set statusline=%f\ %y\ %m\ %r\ %=Size:%{getfsize(expand('%'))}\ bytes

" Always show the status line.
set laststatus=2


" ============================================================================
" === Startup Message ===
" ============================================================================
"
" Show a message when Vim starts.
autocmd VimEnter * echom "The truth is out there."


" ============================================================================
" === Indentation Shortcuts ===
" ============================================================================
"
" In insert mode, Shift-Tab decreases indentation.
inoremap <S-Tab> <C-d>

" In normal mode, Shift-Tab shifts the current line left.
nnoremap <S-Tab> <<

" In visual mode, Shift-Tab shifts the selected block left
" and reselects it so you can continue adjusting indentation.
vnoremap <S-Tab> <gv


" ============================================================================
" === Auto-Pairs and Insert Helpers ===
" ============================================================================
"
" Automatically insert matching parentheses and place cursor inside.
>>>>>>> Stashed changes
inoremap ( ()<Left>

" Automatically insert matching braces and place cursor inside.
inoremap { {}<Left>

" Automatically insert matching brackets and place cursor inside.
inoremap [ []<Left>

" Automatically insert matching single quotes and place cursor inside.
inoremap ' ''<Left>

" Automatically insert matching double quotes and place cursor inside.
inoremap " ""<Left>
<<<<<<< Updated upstream
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
=======

" If you press Enter immediately after typing {,
" create a new indented block and place the cursor inside it.
inoremap {<CR> {<CR>}<Esc>O


" ============================================================================
" === Comment Writing Helpers ===
" ============================================================================
"
" If the current line is exactly /** and you press Enter,
" expand it into a Doxygen/Javadoc-style comment block.
inoremap <expr> <CR> getline('.') =~ '^\s*/\*\*$' ? '<CR> * <CR>*/<Esc>kA' : '<CR>'

" Insert a block comment skeleton with Ctrl-_.
" Many terminals send Ctrl-/ as Ctrl-_.
inoremap <C-_> /*  */<Left><Left><Left>

" Alternate mapping for Ctrl-/ in terminals that support it directly.
inoremap <C-/> /*  */<Left><Left><Left>


" ============================================================================
" === Plugin-Specific Settings ===
" ============================================================================
"
" Enable rainbow parentheses/brackets if the plugin is installed.
" This setting only has an effect when the plugin exists.
let g:rainbow_active = 1


" ============================================================================
" === Build Settings for C ===
" ============================================================================
"
" Use gcc when running :make.
"
" Flags:
" -std=c11                  use the C11 standard
" -Wall                     enable common warnings
" -Wextra                   enable extra warnings
" -g                        include debug symbols
" -O0                       disable optimization for easier debugging
" -fsanitize=address        enable AddressSanitizer
" -fno-omit-frame-pointer   improve stack traces for debugging
"
" %    = current file
" %<   = current filename without extension
set makeprg=gcc\ -std=c11\ -Wall\ -Wextra\ -g\ -O0\ -fsanitize=address\ -fno-omit-frame-pointer\ %\ -o\ %<

" Tell Vim how gcc formats its error messages,
" so :make can populate the quickfix list correctly.
set errorformat=%f:%l:%c:\ %m


" ============================================================================
" === C File Build and Run Shortcuts ===
" ============================================================================
"
" Group related autocommands together so they can be cleared and redefined safely.
augroup CBuildRun
  autocmd!

  " F5 = save file, compile it, open quickfix window if there are errors,
  " and redraw the screen.
  autocmd FileType c nnoremap <buffer> <F5> :w<CR>:silent make<CR>:cwindow<CR>:redraw!<CR>

  " F6 = save file, compile it, clear terminal output, and run the program.
  autocmd FileType c nnoremap <buffer> <F6> :w<CR>:silent make<CR>:!clear; ./%:r<CR>
augroup END


" ============================================================================
" === Quickfix and Search Shortcuts ===
" ============================================================================
"
" Jump to the next quickfix error.
nnoremap ]q :cnext<CR>

" Jump to the previous quickfix error.
nnoremap [q :cprev<CR>

" Close the quickfix window.
nnoremap <leader>q :cclose<CR>

" Clear search highlighting.
nnoremap <leader>n :nohlsearch<CR>
>>>>>>> Stashed changes
