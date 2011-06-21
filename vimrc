set title
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
set ts=4
let perl_fold = 1
let perl_fold_blocks = 1
let perl_extended_vars = 1
let perl_want_scope_in_variables = 1
let perl_include_pod = 1
let php_sql_query = 1
let php_htmlInStrings = 1
set foldlevel=999
let g:miniBufExplMapWindowNavVim = 1

map <f5> :TlistToggle<CR>

  function! PerlMap()
    map <f1> :w<CR>:!perl %<CR>
    map <f2> :w<CR>:!perl -c %<CR>
    map <f3> :w<CR>:!perldoc %<CR>
    map <f4> :w<CR>:!podchecker %<CR>
	set number
  endfunction

autocmd Filetype perl call PerlMap()

augroup filetype
    au! BufRead,BufNewFile *.html           set filetype=mason number
    au! BufRead,BufNewFile *.m              set filetype=mason number
    au! BufRead,BufNewFile autohandler      set filetype=mason number
    au! BufRead,BufNewFile syshandler       set filetype=mason number
    au! BufRead,BufNewFile dhandler         set filetype=mason number
    au! BufRead,BufNewFile *.mas            set filetype=mason number
    au! BufRead,BufNewFile *.comp           set filetype=mason number
    au! BufRead,BufNewFile *.pp             set filetype=puppet number
augroup END

" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

if has("gui_running") 
   colorscheme sand
else
  if &t_Co == 256
   colorscheme xoria256
  else
   colorscheme ir_black
  endif
endif

if has("gui_macvim")
	set transparency=15
endif

syntax on

if &t_Co > 2 || has("gui_running")
  set hlsearch
  highlight Search    NONE
  highlight Comment  ctermfg=white ctermbg=blue cterm=none
endif
