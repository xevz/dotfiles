set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'vim-scripts/slimv.vim'
"Plug 'vim-scripts/omlet.vim'

Plug 'jimenezrick/vimerl'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'xevz/vim-sshauthkeys'
Plug 'vim-ruby/vim-ruby'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'derekwyatt/vim-scala'
Plug 'godlygeek/tabular'

call plug#end()

syntax on
filetype plugin indent on

set autoindent
set cindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set backspace=2

set number
set ruler

set background=light

set nobackup

set noincsearch
set showmatch
set hlsearch

set laststatus=2
set statusline=%F\ %y%m%=\ %{strlen(&fenc)?'['.&fenc.']':''}[%{&ff}]\ %c%V\ %l\,%L\ %P

set tabline=%!ShortTabLine()

set wildmenu
set wildmode=list:longest,full

set tags=tags;/

if has("folding")
	set foldenable
	set foldmethod=marker
endif

" Current directory follows the file being edited, unless it's a remote file
if exists(":lcd")
	autocmd BufEnter * if bufname("") !~ '^[[:alnum:]]*://' | silent! lcd %:p:h | endif
else
	autocmd BufEnter * if bufname("") !~ '^[[:alnum:]]*://' | cd %:p:h | endif
endif

" Some settings for :TOhtml
if exists(":TOhtml")
	let g:html_use_css = 1
	let g:html_number_lines = 1
endif

" I prefer 16 color mode in the terminal
if &t_Co == 256
    let g:rehash256 = 1
    let g:molokai_original = 1
    set background=dark
    colorscheme molokai
elseif &t_Co > 16
	set t_Co=16
endif

" Backslash is a pain to reach on Swedish layouts
let mapleader = ","
let localmapleader = "\\"

" Language specific settings {{{
let c_C99 = 1

augroup lang_Ruby
	autocmd FileType ruby set expandtab tabstop=2 shiftwidth=2
augroup END

" }}}

" Helper functions {{{

function! ShortTabLine()
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

" }}}

if filereadable(glob('~/.vimrc.local'))
	source ~/.vimrc.local
endif

