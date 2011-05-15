set nocompatible
set tabstop=4
set shiftwidth=4
set backspace=2
set number
set ruler
set background=light
set autoindent
set cindent
set nobackup
set noincsearch
set showmatch
set laststatus=2
set hlsearch
set statusline=%F\ %y%m%=\ %{Filenc()}[%{&ff}]\ %c%V\ %l\,%L\ %P

set wildmenu
set wildmode=list:longest,full

set tags=tags;/

syntax on
filetype plugin on
filetype indent on

" Current directory follows the file being edited, unless it's a remote file
if exists(":lcd")
	autocmd BufEnter * if bufname("") !~ '^[[:alnum:]]*://' | silent! lcd %:p:h | endif
else
	autocmd BufEnter * if bufname("") !~ '^[[:alnum:]]*://' | cd %:p:h | endif
endif

" Some settings for :TOhtml
if exists(":TOhtml")
	let g:html_use_css = 1
	let g:html_use_xhtml = 1
	let g:html_number_lines = 1
endif

" Folding
if version >= 600
	set foldenable
	set foldmethod=marker
endif

function Filenc()
	if &fileencoding != ""
		return "[" . &fileencoding . "]"
	else
		return ""
	endif
endfunction

if $TERM == "rxvt-unicode"
	set t_Co=16
endif

let mapleader = ","

let g:erlangFold = 0
let g:erlangHighlightBif = 1
let c_C99 = 1

let g:slimv_client = 'python ~/.vim/ftplugin/slimv.py -r "urxvt -T Slimv -e @p @s -l clisp -s"'

function ShortTabLine()
	let ret = ''

	for i in range(tabpagenr('$'))
		" select the color group for highlighting active tab
		if i + 1 == tabpagenr()
			let ret .= '%#errorMsg#'
		else
			let ret .= '%#TabLine#'
		endif
		" find the buffername for the tablabel
		let buflist = tabpagebuflist(i+1)
		let winnr = tabpagewinnr(i+1)
		let buffername = bufname(buflist[winnr - 1])
		let filename = fnamemodify(buffername,':t')

		" check if there is no name
		if filename == ''
			let filename = 'noname'
		endif

		let ret .= '['.filename.']'
	endfor

	" after the last tab fill with TabLineFill and reset tab page #
	let ret .= '%#TabLineFill#%T'

	return ret
endfunction

set tabline=%!ShortTabLine()

" Templates
function! LoadTemplate()
	silent! 0r ~/.vim/skel/tmpl.%:e

	" Highlight %VAR% placeholders with the Todo colour group
	syn match Todo "%\u\+%" containedIn=ALL
endfunction

autocmd! BufNewFile * call LoadTemplate()

" Jump between %VAR% placeholders in Normal mode with <Ctrl-p>
nnoremap <c-p> /%\u.\{-1,}%<cr>c/%/e<cr>
" Jump between %VAR% placeholders in Insert mode with <Ctrl-p>
inoremap <c-p> <ESC>/%\u.\{-1,}%<cr>c/%/e<cr>

