" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug-ins
call plug#begin('~/.vim/bundle')

Plug 'tell-k/vim-autopep8'
Plug 'vim-scripts/indentpython.vim'
Plug 'nvie/vim-flake8'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plug '', {'branch': 'release'}

Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes' " Vim colorschemes

Plug 'Townk/vim-autoclose' " Auto-close braces

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'airblade/vim-gitgutter'

Plug 'gko/vim-coloresque'

Plug 'junegunn/goyo.vim'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'christoomey/vim-tmux-navigator'

Plug 'arcticicestudio/nord-vim'

Plug 'ryanoasis/vim-devicons'

Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'psf/black', { 'branch': 'stable' }

Plug '~/.vim/bundle/earthy-vim'

call plug#end()

let python_highlight_all=1

highlight BadWhitespace ctermbg=red guibg=#BF616A
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
autocmd BufWritePre *.py execute ':Black'

set encoding=utf-8
" set relativenumber
set number
set mouse=a

set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
set modeline

set nocursorline
set smartindent
set autoindent
set fileformat=unix

let g:enable_bold_font = 1
let g:enable_italic_font = 1
let g:earthy_uniform_status_lines = 0

let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

" let g:gitgutter_sign_added = '烙'
" let g:gitgutter_sign_modified = 'ﯽ'

let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▁'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▎▔'

let g:go_version_warning = 0
colorscheme earthy
set background=dark


if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    " hi MatchParen gui=bold guifg=#88C0D0 guibg=none
endif

if (has("termguicolors"))
    set termguicolors
endif

" colorscheme wpgtk
" set notermguicolors
" hi LineNr ctermbg=0


" hi Normal ctermbg=None

map! <silent> <expr> fd pumvisible() ? "<Esc><Esc>" : "<Esc>"

let mapleader = " "
let g:notes_directories = ['~/Documents/Notes/']
let g:notes_unicode_enabled = 1

" Remap Space+direction keys to move across splits
nnoremap <C-j> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-h> <C-W><C-H>
nnoremap <C-l> <C-W><C-L>

nnoremap <C-Y> <C-W>>
nnoremap <C-O> <C-W><
nnoremap <C-U> <C-W>+
nnoremap <C-I> <C-W>-

" Remap ; to Ctrl-P
nmap ; :CtrlPBuffer<CR>

" Remap Space+NE to open toggle NERDTree
nnoremap <leader>ne :NERDTreeToggle<cr>

if !has('nvim')
    set ttymouse=xterm2
endif

set pastetoggle=<Insert>

" I'm bad at pressing shift at the right time
command! W :w
command! Q :q
command! WQ :wq

source $HOME/.vim/cocSetup.vim
