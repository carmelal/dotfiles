set nocompatible

" Importing plug-ins
call plug#begin()
Plug 'cocopon/iceberg.vim' " colour scheme
Plug 'dense-analysis/ale' " linting
Plug 'github/copilot.vim' " Github Copilot AI
Plug 'junegunn/fzf' " fuzzy finder
Plug 'junegunn/fzf.vim' " fuzzy finder for vim
Plug 'preservim/nerdtree' " showing file tree
Plug 'sheerun/vim-polyglot' " syntax highlighting
Plug 'tomtom/tcomment_vim' " easy commenting
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-surround' " easy surrounding
Plug 'vim-airline/vim-airline' " status bar customization
Plug 'vim-airline/vim-airline-themes' " themes for status bar
call plug#end()

" ===============
" >> Remaps
" ===============
let mapleader=" "
noremap j h
noremap k j
noremap l k
noremap ; l
noremap 'k <C-d>
noremap 'l <C-u>
noremap 0 _
nnoremap U <C-r>
noremap hh <C-w>w
noremap HH :sbuffer<CR>
nnoremap <silent> <Tab> :bn<CR>:while &buftype == 'terminal' \| bnext \| endwhile<CR>
nnoremap <silent> <S-Tab> :bp<CR>:while &buftype == 'terminal' \| bprev \| endwhile<CR>

" define a custom command to close the current buffer and switch to the previous one
command! BD call CustomBufDelete()
nnoremap <S-Backspace> :BD<CR>

" ===============
" >> Settings
" ===============

" Misc settings
set showcmd " show typed command
set timeoutlen=500 " shortens wait time between keystrokes

" Interface
set showmatch " highlights matching brackets
hi MatchParen cterm=underline
set background=dark " dark theme
set t_Co=256 " 256 colour
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" Syntax highlighting
syntax on " enable syntax highlighting
set re=0 " use new regexp engine so VIM doesn't hate TS

" Indentation
set expandtab " tabs become spaces
filetype indent on " check filetype for indent size

" Lines
set nu rnu
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if &buftype != 'terminal' | set nu rnu | endif " hybrid when in normal or visual if not terminal
  autocmd BufLeave,FocusLost,InsertEnter * if &buftype != 'terminal' | set nu nornu | endif " absolute when in insert if not terminal
augroup END
set wrap " softwrap text at edge of screen
set linebreak " don't wrap in the middle of a word

" Terminal settings
nnoremap term :vert term ++cols=75<CR>
autocmd TerminalOpen * setlocal nonumber norelativenumber signcolumn=no " terminal doesn't have sign column
autocmd WinEnter * if (
  \ winnr('$') == 1 &&
  \ &buftype == 'terminal' &&
  \ len(filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") != "terminal"')) == 0
  \ ) | qa! | endif " closes terminal if it's the only window open

" Search-related settings
" search and replace
nnoremap snrp :%s/\<<C-r><C-w>\>/
set ignorecase " not case-sensitive for lowercase
set smartcase " case-sensitive only for uppercase
set incsearch " shows results as typing

" Window settings
set splitbelow " splits are below
set splitright " splits are to the right
nnoremap = :vert res +10<CR>
nnoremap - :vert res -10<CR>
nnoremap ] :res +5<CR>
nnoremap [ :res -5<CR>

" Cursor settings
let &t_SI.="\e[4 q" " blinking underscore in insert mode
let &t_SR.="\e[5 q" " vertical bar in replace mode
let &t_EI.="\e[2 q" " solid block otherwise
autocmd InsertEnter,InsertLeave * set cul! " shows cursor line in insert mode
set scrolloff=4 " always show 4 lines above/below cursor where possible

" Ignoring typos
command! W w
command! Q q
command! Wq wq
command! WQ wq

" ===============
" >> Plugins
" ===============

" ALE
let g:ale_sign_column_always=1 " always show linting column
let g:ale_php_phpcs_standard='PSR12' " use PSR12 for PHP
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint', 'prettier'],
\   'ruby': ['rubocop'],
\   'eruby': ['erblint'],
\   'scss': ['stylelint'],
\   'html': ['html_beautify'],
\   'go': ['gofmt'],
\   'lua': ['stylua'],
\}
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_linters = {
\   'ruby': ['solargraph'],
\   'javascript': ['tsserver'],
\   'go': ['gopls'],
\   'lua': ['luacheck', 'selene'],
\}
let g:ale_root = {
\   'ruby': ['Gemfile', '.git'],
\   'javascript': ['package.json', '.git'],
\   'go': ['go.mod', '.git'],
\   'lua': ['.luarc.json', '.git'],
\}
let g:ale_fix_on_save = 1 " fix linting errors on save
" go to definition
nnoremap <leader>gd = :ALEGoToDefinition<CR>
" find references
nnoremap <leader>gr = :ALEFindReferences<CR>
" open quickfix window
nnoremap <leader>ge = :lopen<CR>
" go to next error
nnoremap <silent> <leader>gn <Plug>(ale_next_wrap)
" go to previous error
nnoremap <silent> <leader>gN <Plug>(ale_previous_wrap)

" FZF
set rtp+=~/.fzf
let g:fzf_layout = { 'down': '20%' }
" exclude certain directories from fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!{sorbet/rbi/**,node_modules/**,.git/**,tmp/**,log/**,coverage/**,vendor/**,public/assets/**,bin/**,sig/**}"'

" NERDTree
nmap qq :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " close nerdtree window if is the only window open
let NERDTreeShowHidden=1 " show hidden files too

" Airline
let g:airline#extensions#ale#enabled = 1 " integrate with ALE
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='angr'

" Colour scheme
colo iceberg

" ===============
" >> Functions
" ===============

" Custom function to delete the current buffer without closing the window
function! CustomBufDelete()
  let l:buf_to_delete = bufnr('%')
  bnext
  if &buftype == 'terminal'
    bnext
  endif
  execute 'bdelete ' . l:buf_to_delete
endfunction
