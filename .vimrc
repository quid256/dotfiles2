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

Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes' " Vim colorschemes

Plug 'Townk/vim-autoclose' " Auto-close braces

" Plug 'vim-airline/vim-airline' "Powerline (having some trouble integrating
" with color scheme

Plug 'ctrlpvim/ctrlp.vim'

Plug 'christoomey/vim-tmux-navigator'
" Plug 'morhetz/gruvbox'

Plug 'kristijanhusak/vim-hybrid-material'

Plug 'ryanoasis/vim-devicons'

Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'

call plug#end()

let python_highlight_all=1

highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

set encoding=utf-8
set relativenumber
set number
set mouse=a

set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4

set nocursorline
set smartindent
set autoindent
set fileformat=unix

let g:enable_bold_font = 1
let g:enable_italic_font = 1
let g:hybrid_transparent_background = 1

if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    hi Normal guibg=None
endif

if (has("termguicolors"))
    set termguicolors
endif

set background=dark
colorscheme hybrid_material

hi Normal ctermbg=None

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

inoremap <C-S> <Esc>:w<CR>
vnoremap <C-S> <Esc>:w<CR>

inoremap <C-W> <Esc>:q<CR>
vnoremap <C-W> <Esc>:q<CR>

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

source /home/chris/.vim/cocSetup.vim
