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

" UI Tweaks
set ruler
set bg=dark
set number
set showmode
set nohlsearch
set cursorline
set laststatus=2
set statusline=%{fugitive#statusline()}

" Tab handling
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
" Auto-complete settings
set complete=.,b,u,]
" Enable tags:
set tags=./tags;/

" Maps and Functions
map <f2> :NERDTreeToggle<CR>
map <f5> :TlistToggle<CR>
set pastetoggle=<F3>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

function WordProcess()
    set tw=76
    set spelllang=en_us
    set spell
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

" Auto commands and filetype assignment
augroup filetype
    au! BufRead,BufNewFile *.html           set filetype=mason
    au! BufRead,BufNewFile *.m              set filetype=mason
    au! BufRead,BufNewFile autohandler      set filetype=mason
    au! BufRead,BufNewFile syshandler       set filetype=mason
    au! BufRead,BufNewFile dhandler         set filetype=mason
    au! BufRead,BufNewFile *.mas            set filetype=mason
    au! BufRead,BufNewFile *.comp           set filetype=mason
    au! BufRead,BufNewFile *.pp             set filetype=puppet
    au! BufRead,BufNewFile *.psgi           set filetype=perl
    au! BufRead,BufNewFile *.txt            set filetype=text
    au! BufRead,BufNewFile *.patch          let b:noStripWhitespace = 1
augroup END

autocmd Filetype text call WordProcess()
autocmd Filetype markdown call WordProcess()
autocmd BufWritePre * call StripTrailingWhitespace()


" Vundle Plugin Configurations
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'
" Color schemes
Bundle 'altercation/vim-colors-solarized'
let g:solarized_termtrans = 1
let g:solarized_termcolors = 256
let g:solarized_visibility = "high"
Bundle 'tomasr/molokai'
" UI Plugins
Bundle 'ack.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'Lokaltog/vim-powerline'
let g:Powerline_symbols = 'fancy'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'troydm/easybuffer.vim'
Bundle 'godlygeek/tabular'
Bundle 'nathanaelkane/vim-indent-guides'
" Git integration
Bundle 'tpope/vim-fugitive'
" Perl Syntax Highlighting
Bundle 'c9s/perlomni.vim'
Bundle 'vim-perl/vim-perl'
let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_include_pod = 1
Bundle 'yko/mojo.vim'
let mojo_highlight_data = 1
" Make working with Ruby less violent
Bundle 'tpope/vim-endwise'
" Other Languages
Bundle 'vim-scripts/Vim-R-plugin'
" Markup/Serialization Language Support
Bundle 'Rykka/riv.vim'
Bundle 'tpope/vim-markdown'
Bundle 'leshill/vim-json'
" Sysadmin Stuff
Bundle 'zaiste/tmux.vim'
Bundle 'vim-scripts/iptables'
Bundle 'rodjek/vim-puppet'

if has("gui_running")
    colorscheme solarized
    set mousefocus
else
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
