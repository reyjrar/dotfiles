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

" Adding Pathogen
call pathogen#infect()

let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_include_pod = 1
let g:Powerline_symbols = 'fancy'

" MiniBufExplorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

map <f2> :NERDTreeToggle<CR>
map <f5> :TlistToggle<CR>

function WordProcess()
	set tw=76
	set spelllang=en_us
	set spell
endfunction

augroup filetype
    au! BufRead,BufNewFile *.html           set filetype=mason number
    au! BufRead,BufNewFile *.m              set filetype=mason number
    au! BufRead,BufNewFile autohandler      set filetype=mason number
    au! BufRead,BufNewFile syshandler       set filetype=mason number
    au! BufRead,BufNewFile dhandler         set filetype=mason number
    au! BufRead,BufNewFile *.mas            set filetype=mason number
    au! BufRead,BufNewFile *.comp           set filetype=mason number
    au! BufRead,BufNewFile *.pp             set filetype=puppet number
    au! BufRead,BufNewFile *.txt            set filetype=text number
augroup END

autocmd Filetype text call WordProcess()

if has("gui_running")
    set bg=light
    colorscheme solarized
else
	colorscheme molokai
endif

if has("gui_macvim")
	set transparency=15
endif

syntax on
filetype on
filetype plugin on
filetype indent on

" borrowed from: https://github.com/ellzey/dotfiles/blob/master/vimrc#L98
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
