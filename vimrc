set title
set number
set ignorecase
set smartcase
set ruler
set noexpandtab
set nostartofline
set showmatch
set showcmd
set showmode
set magic
set ttyfast
set bg=dark
set bs=2
set vb t_vb=
set dir=~/.vimswap

" Tab handling
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set smartindent

let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_include_pod = 1
set nofoldenable

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
   colorscheme sand
else
	colorscheme molokai
endif

if has("gui_macvim")
	set transparency=15
endif


if &t_Co > 2 || has("gui_running")
  set hlsearch
  highlight Search    NONE
  highlight Comment  ctermfg=white ctermbg=blue cterm=none
endif

syntax on
filetype on
filetype plugin on
filetype indent on

" borrowed from: https://github.com/ellzey/dotfiles/blob/master/vimrc#L98
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
