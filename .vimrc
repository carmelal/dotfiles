set nocompatible

" ===============
" >> Plugins
" ===============

" Importing plug-ins
call plug#begin()
Plug 'cocopon/iceberg.vim' " colour scheme
Plug 'dense-analysis/ale' " linting
Plug 'junegunn/fzf' " fuzzy finder
Plug 'junegunn/fzf.vim' " fuzzy finder for vim
Plug 'nathanaelkane/vim-indent-guides' " indent guides
Plug 'preservim/nerdtree' " showing file tree
Plug 'sheerun/vim-polyglot' " syntax highlighting
Plug 'tomtom/tcomment_vim' " easy commenting
Plug 'vim-airline/vim-airline' " status bar customization
Plug 'vim-airline/vim-airline-themes' " themes for status bar
call plug#end()

" Iceberg.vim
" TODO: only use colour if checked installed
colo iceberg

" ALE
let g:ale_php_phpcs_standard='PSR12' " use PSR12 for PHP
let g:ale_sign_column_always=1 " always show linting column
let g:ale_open_list = 1 " open window showing errors
" TODO: add more linters
" not sure if these work yet
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint', 'prettier'],
\   'typescript': ['eslint', 'prettier'],
\   'ruby': ['rubocop'],
\}
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_fix_on_save = 1 " fix linting errors on save

" FZF
set rtp+=~/.fzf
let g:fzf_layout = { 'down': '20%' }

" NERDTree
nmap qq :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " close nerdtree window if is the only window open
let NERDTreeShowHidden=1 " show hidden files too

" Airline
let g:airline#extensions#ale#enabled = 1 " integrate with ALE
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='angr'

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

" Line numbers
runtime working.vim " always start with custom mappings
command Vimnum :call ToggleNumbering() " :Vimnum toggles between showcase.vim and working.vim

" Terminal settings
nnoremap term :vert term ++cols=75<CR>
autocmd BufEnter * if (&buftype == 'terminal') | set nonu nornu | endif " TODO: fix event
autocmd BufEnter * if (winnr("$") == 1 && &buftype == 'terminal') | q! | endif " closes side terminal if is the only window open

" Search-related settings
nnoremap snrp :%s/\<<C-r><C-w>\>/
set ignorecase " not case-sensitive for lowercase
set smartcase " case-sensitive only for uppercase
set incsearch " shows results as typing
" TODO: automatically open cw
nnoremap grep :vimgrep!//j **/*<Left><Left><Left><Left><Left><Left><Left>
nnoremap wgrep :vimgrep!/<C-r><C-w>/j **/*<CR> :copen<CR>

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

" Remapping
noremap 0 _
nnoremap U <C-r>
nnoremap bd :bd<CR>
nnoremap bn :bn<CR>
nnoremap bv :bp<CR>
let mapleader=" "
" TODO: figure out how to use GRIP nicely
" nnoremap <leader>5 :!grip %<CR>

" Toggle remapping
runtime carmela.vim " always start with custom mappings
command Vimrc :call ToggleVimrc() " :Vimrc toggles between carmela.vim and pairing.vim

" ===============
" >> Functions
" ===============

function ToggleNumbering()
  if g:showcase == 1
    runtime working.vim
    echom "Changed to working.vim"
  else
    runtime showcase.vim
    echom "Changed to showcase.vim"
  endif
endfunction

function ToggleVimrc()
  if g:custom == 1
    runtime pairing.vim
    echom "Changed to pairing.vim"
  else
    runtime carmela.vim
    echom "Changed to carmela.vim"
  endif
endfunction
