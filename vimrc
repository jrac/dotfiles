colorscheme solarized
set nowrap
"set backup							" Turn backups on
"set backupext=".bak"				" Append `.bak' to backups
"set backupdir="~/.backups/"	" Directory to save backups in
set showmatch
set noerrorbells					" No error bells
set showmode
set title							" Terminal window title
set ttyfast							" Smoother scrolling
set more								" Use more instead of flooding screen

set tabstop=3
set shiftwidth=3
"set softtabstop=4

set smartindent
set smarttab
set viminfo=%,'50,\"100,:100,n~/.viminfo
set ruler							" Turn on ruler
set bs=2								" Backspacing over everything
set hls								" Highlight search patterns
set ic								" Case-insensitive searches
set shm+=I							" No start up message
set sm								" Show bracket match
set dir=/tmp						" Temp dir
set clipboard=unnamed			" Universal clipboard
set shortmess=tWwirx
set ww+=<,>,[,]					" Don't wrap to next line when using homerow movement keys at end of line
set t_Co=8							" Use 
set background=dark
set cpoptions+=B
set history=150					" Keep 150 lines in history
set expandtab						" Tabs = spaces
set smartcase
set hidden
set ignorecase
set pastetoggle=<f11>			" Try to place nice with paste from external window/app
"set nostartofline
set undolevels=1000
set updatecount=500  			" Write swap file to disk after each 500 characters
set updatetime=6000				" Write swap file to disk after 5 inactive seconds
set whichwrap=<,>					" Don't wrap to previous line when using homerow movement keys at start of line
set wrapmargin=1
"set digraph						" Support non-ASCII character inserts
set nottybuiltin
set laststatus=2
set printoptions=paper:letter,number:y,portrait:y
set listchars+=precedes:<,extends:>
set textwidth=0

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

if version >= 600
  set foldenable
  set foldmethod=marker
endif

set statusline=%<%F%m%=#%n\ %([%R]%)\ %([%Y]%)\ %P\ <%l,%c%V>

if has("syntax") && &t_Co > 2
    syntax on
    so $VIMRUNTIME/syntax/syntax.vim		    " Load filetypes for
endif

map :W :w
map :Q :q
noremap :q :nohl<Cr>:q!
map ,wrap :set wrap<Cr>:set wrapmargin=1<Cr>:set tw=79<Cr>
map ,nowrap :set nowrap<Cr>:set wrapmargin=0<Cr>
map ,nl :nohl<CR>
"map :o :e
"map <C-Z> :shell

" Switch buffers with Ctrl+N/P
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>

vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"copy and paste betweeen different vim sessions
nmap  _Y  :!echo ""> ~/.vi_tmp<CR><CR>:w! ~/.vi_tmp<CR>
vmap  _Y  :w! ~/.vi_tmp<CR>
nmap  _P  :r ~/.vi_tmp<CR
map <C-t> <Esc>:call TransposeChars(line("."),col("."))<CR>a
map <C-t> :call TransposeChars(line("."),col("."))<CR>
"map <C-x> :call StripTrailingWhiteSpace()<CR>:wq<CR>
"imap <C-x> <Esc>:call StripTrailingWhiteSpace()<CR>:wq<CR>

filetype plugin indent on

" Format text
imap <C-J> <C-O>gqap
nmap <C-J>      gqap
vmap <C-J>      gq

"map <S-F5> :!galeon % &<Cr>

" Insert current time
map <C-D>  o<C-R>=strftime("%a %b %d %T %Z %Y")<C-M><C-M>
imap <C-D> <C-R>=strftime("%a %b %d %T %Z %Y")<C-M><C-M>
vmap <C-D> o<C-R>=strftime("%a %b %d %T %Z %Y")<C-M><C-M>

" Strip unnecessary whitespace with a non-recursive mapping
noremap :wq :call StripTrailingWhiteSpace()<Cr>:wq

" Removes unneccessary whitespace
function StripTrailingWhiteSpace()
	let line_num = 1

	" Loop through all the lines in the file
	while line_num <= line("$")
		let line = getline(line_num)

		" Remove trailing whitespace
		let line = substitute(line, '[ \t]\+$', '', '')

		" Convert spaces to tabs
		let line = substitute(line, ' \{8}', '\t', 'g')

		" Remove spaces before tabs
		let line = substitute(line, '\( \+\)\t', StrRepeat('\t',1 + strlen("\1") / 8), 'g')

		call setline(line_num, line)

		let line_num = line_num + 1
	endwhile
endfunction

" Transposes adjacent characters
function TransposeChars(lineno,col)
	let line = getline(a:lineno)
	let line = strpart(line,0,a:col - 1) . strpart(line,a:col,1) . strpart(line,a:col - 1,1) . strpart(line,a:col + 1,strlen(line) - a:col - 1)
	call setline(a:lineno,line)
endfunction

function StrRepeat(seq,times)
	let str = ""
	let i = 0

	while i < a:times
		let str = str . a:seq
		let i = i + 1
	endwhile

	return str
endfunction

function! CHANGE_CURR_DIR()
	let _dir = expand("%:p:h")
	exec "cd " . _dir
	unlet _dir
endfunction

if has("autocmd")
autocmd BufEnter * call CHANGE_CURR_DIR()
autocmd BufRead *.gz set bin|%!gunzip
autocmd BufRead *.gz set nobin
autocmd BufWritePre *.gz %!gzip
autocmd BufWritePre *.gz set bin
autocmd BufWritePost *.gz undo|set nobin
autocmd FileReadPost *.gz set bin|'[,']!gunzip
autocmd FileReadPost set nobin
" Auto set text with for text files
autocmd FileType text setlocal textwidth=79
autocmd BufNewFile *.txt		       set tw=79
autocmd BufRead    *.txt		       set tw=79
" Auto chmod +x on shell scripts
autocmd BufWritePost   *.sh	     !chmod +x %
autocmd BufWritePost   *.pl	     !chmod +x %

au! BufEnter *.c,*.cc,*.h map <F6> :!man <cword><Cr>
au! BufEnter *.c,*.cc,*.h map! <F6> <Esc>:!man <cword><Cr>i
au! BufEnter *.pl,*.cgi map <F6> :!perldoc -f <cword><Cr>
au! BufEnter *.pl,*.cgi map! <F6> <Esc>:!perldoc -f <cword><Cr>i

endif

if has("gui_running")

    set go=brmaT									       " GUI options
    "set ts=4
    set tb=none
    set tbis=small
    "set guifont=-ttf-lucida\ console-medium-r-normal-*-*-100-*-*-m-*-iso8859-1
    "set guifont=Courier\ 10\ Pitch\ 10	
    set mh												" Hide cursor while entering characters
    set mousem=popup
    set km=startsel,stopsel
    set selection=exclusive						" Allow one char past EOL
    set lines=52
    set columns=117								     " When executing external commands, stop the resizing:
    win 91 48

	 " Shift-insert paste external clipboard buffers
	 map  <silent>  <S-Insert>  "+p
    imap <silent>  <S-Insert>  <Esc>"+pa

endif
