" Features
set nocompatible                                " Don't try to run in vi-compatible mode
set autoread                                    " Reload files changed outside the editor
set title                                       " Attempt to set the terminal title
set ignorecase                                  " Ignore case in searches
set smartcase                                   "  ^- except when I use case
set nostartofline                               " Commands evaluate from cursor position
set showmatch
set showcmd
set magic
set ttyfast
set bs=2                                        " Backspace can wrap
set vb t_vb=                                    " Ignore Bells
set dir=~/.vimswap
set nofoldenable                                " Disable folding
set nowrap                                      " Do not wrap lines
set encoding=utf-8
set modeline
set modelines=5
if has('termguicolors')
    set termguicolors
endif

" UI Tweaks
set ruler
set bg=dark
set number
set showmode
set nohlsearch
set lazyredraw
set nocursorline
set nocursorcolumn
highlight CursorColumn ctermbg=234
set laststatus=2

" Tab handling
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround
" Auto-complete settings
set complete=.,b,u,]
" Enable tags:
set tags=./tags;/

" Colors
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'

" Maps and Functions
map <f2> :NERDTreeToggle<CR>
map <f5> :TlistToggle<CR>
set pastetoggle=<F3>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

function WordProcess()
    set tw=78
    set spelllang=en_us
    set spell
endfunction

function MailHandler()
    call WordProcess()
    setlocal fo+=aw
endfunction

fun! StripTrailingWhitespace()
    let l:cursorpos = getpos(".")
    " Only strip if the b:noStripWhitespace variable isn't set
    if exists('b:noStripWhitespace')
        return
    endif
    %s/\s\+$//e
    call setpos('.', l:cursorpos)
endfun

" Set tmux tab name
autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))

" Auto commands and filetype assignment
augroup filetype
    au! BufRead,BufNewFile *.mmd             set filetype=markdown
    au! BufRead,BufNewFile *.html            set filetype=mason
    au! BufRead,BufNewFile *.m               set filetype=mason
    au! BufRead,BufNewFile autohandler       set filetype=mason
    au! BufRead,BufNewFile syshandler        set filetype=mason
    au! BufRead,BufNewFile dhandler          set filetype=mason
    au! BufRead,BufNewFile *.mas             set filetype=mason
    au! BufRead,BufNewFile *.comp            set filetype=mason
    au! BufRead,BufNewFile *.pp              set filetype=puppet
    au! BufRead,BufNewFile *.psgi            set filetype=perl
    au! BufRead,BufNewFile *.txt             set filetype=text
    au! BufRead,BufNewFile *.tt              set filetype=tt2html
    au! BufRead,BufNewFile *.tt2             set filetype=tt2html
    au! BufRead,BufNewFile *.patch           let b:noStripWhitespace = 1
    au! BufRead,BufNewFile *.sieve           set ft=sieve ff=unix
    au! BufRead,BufNewFile *.trst            set ft=rst
    au! BufRead,BufNewFile *.yaml            set ts=2 sts=2 sw=2 expandtab
    au! BufRead,BufNewFile *.yml             set ts=2 sts=2 sw=2 expandtab
augroup END

autocmd Filetype text call WordProcess()
autocmd Filetype markdown call WordProcess() | let b:noStripWhitespace = 1
autocmd Filetype mail call MailHandler()
autocmd BufWritePre * call StripTrailingWhitespace()

autocmd StdinReadPre * let s:std_in=1
" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif
" Start NERDTree when Vim starts with a directory argument.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" BEGIN: Conway's Tweaks

" Visual Block mode is far more useful that Visual mode (so swap the commands)...
nnoremap v <C-V>
nnoremap <C-V> v

vnoremap v <C-V>
vnoremap <C-V> v

"Square up visual selections...
set virtualedit=block

" Make BS/DEL work as expected in visual modes (i.e. delete the selected text)...
vmap <BS> x
" When shifting, retain selection over multiple shifts...
vmap <expr> > KeepVisualSelection(">")
vmap <expr> < KeepVisualSelection("<")

function! KeepVisualSelection(cmd)
    set nosmartindent
    if mode() ==# "V"
        return a:cmd . ":set smartindent\<CR>gv"
    else
        return a:cmd . ":set smartindent\<CR>"
    endif
endfunction

" END: Conway's Tweaks

" Vundle Plugin Configurations
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'
" Color schemes
"Plugin 'altercation/vim-colors-solarized'
"let g:solarized_termtrans = 1
"let g:solarized_termcolors = 256
"let g:solarized_visibility = "high"
Plugin 'tomasr/molokai'
let g:molokai_original = 1
let g:rehash256 = 1
Plugin 'morhetz/gruvbox'
" UI Plugins
Plugin 'ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'preservim/nerdtree'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeLimitedSyntax = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['cfg'] = s:beige
let g:NERDTreeExtensionHighlightColor['conf'] = s:beige
let g:NERDTreeExtensionHighlightColor['gz'] = s:red
let g:NERDTreeExtensionHighlightColor['ini'] = s:beige
let g:NERDTreeExtensionHighlightColor['j2'] = s:salmon
let g:NERDTreeExtensionHighlightColor['mkdn'] = s:blue
let g:NERDTreeExtensionHighlightColor['md'] = s:blue
let g:NERDTreeExtensionHighlightColor['pm'] = s:orange
let g:NERDTreeExtensionHighlightColor['pl'] = s:pink
let g:NERDTreeExtensionHighlightColor['t'] = s:yellow
let g:NERDTreeExtensionHighlightColor['tar'] = s:red
let g:NERDTreeExtensionHighlightColor['yaml'] = s:beige
let g:NERDTreeExtensionHighlightColor['yml'] = s:beige
let g:NERDTreeExtensionHighlightColor['zip'] = s:red
"Plugin 'majutsushi/tagbar'
"Plugin 'vim-scripts/SyntaxRange
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'powerlineish'
Plugin 'Raimondi/delimitMate'
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-speeddating'
Plugin 'godlygeek/tabular'
Plugin 'sjl/gundo.vim'
Plugin 'lfilho/cosco.vim'
noremap <silent> ,; :call cosco#commaOrSemiColon()<CR>
" Git integration
Plugin 'tpope/vim-fugitive'
Plugin 'Shougo/neocomplete.vim'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
Plugin 'ryanoasis/vim-devicons'
" Perl Syntax Highlighting
Plugin 'c9s/perlomni.vim'
Plugin 'vim-perl/vim-perl'
let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_include_pod = 1
"let perl_sync_dist = 500
Plugin 'yko/mojo.vim'
let mojo_highlight_data = 1
"Plugin 'motemen/xslate-vim'
" Make working with Ruby less violent
"Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'
" Other Languages
"Plugin 'vim-scripts/Vim-R-plugin'
"Plugin 'exu/pgsql.vim'
"Plugin 'fsouza/go.vim'
Plugin 'rust-lang/rust.vim'
"Plugin 'fatih/vim-go'
" Markup/Serialization Language Support
"Plugin 'Rykka/riv.vim'
Plugin 'tpope/vim-markdown'
Plugin 'leshill/vim-json'
Plugin 'vim-scripts/sieve.vim'
" Sysadmin Stuff
Plugin 'zaiste/tmux.vim'
Plugin 'vim-scripts/iptables'
Plugin 'rodjek/vim-puppet'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'apeschel/vim-syntax-syslog-ng'
"Plugin 'mephux/bro.vim'
" Extensions
"Plugin 'freitass/todo.txt-vim'

call vundle#end()

let iterm_bg = $ITERM_BG
if iterm_bg == "light"
    set background=light
    colorscheme solarized
elseif has("gui_running")
    set background=light
    colorscheme solarized
    set mouse=a
    set mousefocus
else
    set mouse=
    set background=dark
	colorscheme molokai
endif

if has("gui_macvim")
    set transparency=15
endif

filetype plugin on
filetype indent on
syntax on

" borrowed from: https://github.com/ellzey/dotfiles/blob/master/vimrc#L98
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
