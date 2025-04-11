set nocompatible " Must be the first line

" === Global Settings ===
set modeline
set encoding=utf-8
set ignorecase
set smartcase
set foldenable
set foldmethod=marker 
set t_Co=256
set backspace=indent,eol,start 
set incsearch
set lazyredraw
set showmatch
 
 
" === Syntax Highlighting & auto-indent ===
let python_highlight_all=1
syntax on
syntax enable
set ofu=syntaxcomplete#Complete
set antialias
filetype on
filetype plugin on 
filetype indent on
set autoindent
set pastetoggle=<F3>

" Set Comment color
hi Comment guifg=#7C7C7C     guibg=NONE        gui=NONE      ctermfg=darkgray    ctermbg=NONE        cterm=NONE

" """"""""""""""""""
" PLUGIN MANAGEMENT!
" """"""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'

" Autocomplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim/2258b116e81ab308495f94c81077682c39c32280', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim/2258b116e81ab308495f94c81077682c39c32280'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'zchee/deoplete-jedi'

" Python autocomplete
" Plug 'davidhalter/jedi-vim'

" File tree
Plug 'scrooloose/nerdTree'

" Automatic commenting
Plug 'scrooloose/nerdcommenter'

" quoting/parenthesizing
Plug 'tpope/vim-surround'

" Editorconfig support
Plug 'editorconfig/editorconfig-vim'

call plug#end()

" File tree toggle with ctrl+n
nmap <C-n> :NERDTreeToggle<CR>
" Run Black on F9
nnoremap <F9> :Black<CR>

" Enable deoplete
let g:deoplete#enable_at_startup = 1
" Enable powerline font
let g:airline_powerline_fonts = 1

" === Wildmenu ===
set wildmenu
set wildmode=longest,list,full
set wildignore=.svn,CVS,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif

" === Other Settings ===
" Show < or > when characters are not displayed on the left or right.
"set list
"set list listchars=nbsp:¬,tab:>-,precedes:<,extends:>
 
" Set to auto read when a file is changed from the outside 
set autoread
 
" Show More Info in the statusline, without going overboard 
set laststatus=2
set statusline=%<%f\ %m%r%y%=%-35.(Line:\ %l/%L\ [%p%%][Format=%{&ff}]%)

" Set default tab width
set tabstop=4
set shiftwidth=4

" === Coding tweaks ===
" All setting are protected by 'au' ('autocmd') statements.  Only files ending
" in .py or .pyw will trigger the Python settings while files ending in *.c or
" *.h will trigger the C settings. 

au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4
au BufRead,BufNewFile *py,*pyw,*.c,*.h set softtabstop=4
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
 
fu Select_c_style()
    if search('^t', 'n', 150)
        set shiftwidth=8
        set noexpandtab
    el 
        set shiftwidth=4
        set expandtab
    en
endf
au BufRead,BufNewFile *.c,*.h call Select_c_style()
au BufRead,BufNewFile Makefile* set noexpandtab
 
" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red
 
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^t+/
 
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /s+$/
 
" Wrap text after a certain number of characters
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h set textwidth=79
 
" Turn off settings in 'formatoptions' relating to comment formatting.
" - c : do not automatically insert the comment leader when wrapping based on
"    'textwidth'
" - o : do not insert the comment leader when using 'o' or 'O' from command mode
" - r : do not insert the comment leader when hitting <Enter> in insert mode
" Python: not needed, C: prevents insertion of '*' at the beginning of every line in a comment
au BufRead,BufNewFile *.c,*.h set formatoptions-=c formatoptions-=o formatoptions-=r
 
" Use UNIX (n) line endings.
" Only used for new files so existing files aren't forced to change line endings
au BufNewFile *.py,*.pyw,*.c,*.h,*.vim,*.pl,*.sh set fileformat=unix

au BufRead,BufNewFile *.yml,*.yaml set tabstop=2
au BufRead,BufNewFile *.yml,*.yaml set shiftwidth=2
au BufRead,BufNewFile *.yml,*.yaml set softtabstop=2
au BufRead,BufNewFile *.yml,*.yaml set expandtab

" enable line numbers
set nu

set background=dark
