" No Vi-compatible Mode
set nocompatible

" Enable modeline
set modeline
set modelines=5

" Character Encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp949,euc-kr,latin1

" 까만 배경 화면
set background=dark

" BufExplorer 설정
let mapleader = ","
set hidden
set noautowrite
set noautowriteall
set autoread

" 현재 디렉토리가 더럽혀지지 않도록
set directory-=.
set backupdir-=.

" 현재 디렉토리의 .vimrc 로드
set secure
set exrc

" Editing
"set foldmethod=marker
"set commentstring=\ #%s
"set cindent
set autoindent
set backspace=2
set laststatus=2
"set backup

" 탭은 네 칸으로
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Information Displaying
set ruler
set showcmd
set showmatch
set showmode
"set noerrorbells
"set novisualbell

" mouse
set ttymouse=xterm2
set mouse=a

" Searching
set hlsearch
set ignorecase
set smartcase

set iskeyword-=/
set iskeyword+=$

let php_sql_query = 1
syntax on

" cscope DB 다시 만들기
function! ReloadCscope()
	if exists("g:cscope_find")
		" 프로젝트에 맞게 g:cscope_find 변수 설정해야 함
		execute '!cd ' . g:cscope_dir . ' && ' . g:cscope_find . ' > cscope.files && cscope -b'
		cscope reset
	endif
endfunction

" 현재 및 상위 디렉토리의 cscope.out을 찾아서 추가
" 기타 cscope에 유용한 설정
" ~/.vim/plugin/cscope_maps.vim에 추가 설정 있음
if has("cscope")
	set nocscopeverbose
	" 명령 결과를 quickfix 형태로
	set cscopequickfix=s-,t-
	cscope kill 0
	let db = findfile("cscope.out", ",;")
	if db != ""
		let g:cscope_dir = fnamemodify(db, ":p:h")
		execute "cscope add " . db . " " . g:cscope_dir

		" cscope DB 다시 만들기
		map <F5> :call ReloadCscope()<CR>
	endif

    set timeoutlen=4000
    set ttimeout 
    set ttimeoutlen=100

	" cscope 명령 내리기 전에 편집할 기회를 줌
    nmap <C-\><S-s> :cs find s <C-R>=expand("<cword>")<CR>
    nmap <C-\><S-g> :cs find g <C-R>=expand("<cword>")<CR>
    nmap <C-\><S-c> :cs find c <C-R>=expand("<cword>")<CR>
    nmap <C-\><S-t> :cs find t <C-R>=expand("<cword>")<CR>
    nmap <C-\><S-e> :cs find e <C-R>=expand("<cword>")<CR>
    nmap <C-\><S-f> :cs find f <C-R>=expand("<cfile>")<CR>
    nmap <C-\><S-i> :cs find i ^<C-R>=expand("<cfile>")<CR>$
    nmap <C-\><S-d> :cs find d <C-R>=expand("<cword>")<CR>
endif

" quickfix 단축키. 각각 현재, 이전, 다음 항목
map <F2> :cc<CR>
map <F3> :cp<CR>
map <F4> :cn<CR>

" FileType Plugins
au! BufNewFile,BufRead *.php
autocmd BufRead,BufNewFile *.tpl	set filetype=php

autocmd FileType dosini			set tabstop=8 softtabstop=0 shiftwidth=8 noexpandtab

" /etc/vimrc 에서 되돌리기
set nopaste

map <Leader>zo A<space>/*{{{*/<ESC>
map <Leader>zc A<space>/*}}}*/<ESC>

let rc = findfile(".vimrc.local", ",;")
if rc != ""
    execute "source " . rc 
endif
