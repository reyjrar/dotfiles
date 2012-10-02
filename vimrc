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

" Adding Pathogen
call pathogen#infect()

let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_include_pod = 1
let g:Powerline_symbols = 'fancy'
let mojo_highlight_data = 1

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

fun! StripTrailingWhitespace()
    let l:cursorpos = getpos(".")
    " Only strip if the b:noStripeWhitespace variable isn't set
    if exists('b:noStripWhitespace')
        return
    endif
    %s/\s\+$//e
    call setpos('.', l:cursorpos)
endfun

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
augroup END

autocmd Filetype text call WordProcess()
autocmd BufWritePre * call StripTrailingWhitespace()

if has("gui_running")
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
