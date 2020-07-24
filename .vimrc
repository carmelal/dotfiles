" ===============
" >> Plugins
" ===============

" Importing plug-ins
call plug#begin()
Plug 'nathanaelkane/vim-indent-guides' " indent guides
Plug 'preservim/nerdtree' " showing file tree
Plug 'vim-airline/vim-airline-themes' " themes for status bar
Plug 'vim-airline/vim-airline' " status bar customization
Plug 'junegunn/fzf' " fuzzy finder
Plug 'junegunn/fzf.vim' " fuzzy finder for vim
Plug 'cocopon/iceberg.vim' " colour scheme
Plug 'sheerun/vim-polyglot' " syntax highlighting
Plug 'dense-analysis/ale' " linting
Plug 'tomtom/tcomment_vim' " easy commenting
call plug#end()
                                      
" Iceberg.vim
colo iceberg

" ALE
let g:ale_sign_column_always=1 " always show linting column

" FZF
set rtp+=~/.fzf
let g:fzf_layout = { 'down': '20%' }

" NERDTree
nmap qq :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " close nerdtree window if is the only window open
let NERDTreeShowHidden=1 " show hidden files too

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='angr'

" ===============
" >> Settings
" ===============

" Misc settings
syntax on " enable syntax highlighting
set showcmd " show typed command
set tabstop=2 shiftwidth=2 expandtab " set indent width
set timeoutlen=500 " shortens wait time between keystrokes

" Interface
set showmatch " highlights matching brackets
hi MatchParen cterm=underline
set background=dark " dark theme
set t_Co=256 " 256 colour
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" Line numbers
set nu rnu
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set nu rnu " hybrid when in normal or visual
  autocmd BufLeave,FocusLost,InsertEnter * set nornu " absolute when in insert
augroup END

" Terminal settings
nnoremap term :vert term ++cols=75<CR>
autocmd BufEnter * if (&buftype == 'terminal') | set nonu nornu | endif " TODO: fix event
autocmd BufEnter * if (winnr("$") == 1 && &buftype == 'terminal') | q! | endif " closes side terminal if is the only window open

" Search-related settings
nnoremap snrp :%s/\<<C-r><C-w>\>/
set ignorecase " ignores case when searching
set incsearch " shows results as typing
" TODO: figure out best grep settings
 " nnoremap grep :vimgrep//j **/*<Left><Left><Left><Left><Left><Left><Left>
 " nnoremap cgrep :vimgrep/<C-r><C-w>/j **/*<CR> :copen<CR>

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

" Remapping
noremap 0 _
nnoremap U <C-r>

" Ignoring typos
command! W w
command! Q q
command! Wq wq
command! WQ wq

" Toggle remapping
runtime carmela.vim " always start with custom mappings
command Vimrc :call ToggleVimrc() " :Vimrc toggles between carmela.vim and pairing.vim

function ToggleVimrc()
  if g:custom == 1
    runtime pairing.vim
    echom "Changed to pairing.vim"
  else
    runtime carmela.vim
    echom "Changed to carmela.vim"
  endif
endfunction
