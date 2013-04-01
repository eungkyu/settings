" No Vi-compatible Mode
set nocompatible

" vundle 설정
filetype off
set runtimepath+=~/.vim/bundle/vundle/

if !isdirectory(expand("~/.vim/bundle/vundle"))
    echo "Installing vundle\r\n"
    !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    echo "Done"
endif

call vundle#rc()

" github addon
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'bitc/vim-bad-whitespace'
Bundle '2072/PHP-Indenting-for-VIm'
Bundle 'jelera/vim-javascript-syntax'

" vim-scripts addon
Bundle 'bufexplorer.zip'

" git addon
" none

let g:cscope_exts = ''
let rc = findfile(".vimrc.local", ",;")
if rc != ""
    execute "source " . rc
endif

" Enable modeline
set modeline
set modelines=5

" Character Encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp949,euc-kr,latin1

" 배경 화면 설정
if $USE_DARK_BACKGROUND == 'yes'
    set background=dark
else
    set background=light
endif

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

" Searching
set hlsearch
set ignorecase
set smartcase

set iskeyword-=/

let php_sql_query = 1
syntax on

" git cscope 명령을 이용하여 cscope 추가
" 기타 cscope에 유용한 설정
" ~/.vim/plugin/cscope_maps.vim에 추가 설정 있음
if has("cscope")
    " cscope DB 로드하기
    function! CscopeLoad(exts)
        set nocscopeverbose
        cscope kill 0
        execute system("git cscope vim-cmd " . a:exts)
    endfunction

    " cscope DB 다시 만들기
    function! CscopeRebuild(exts)
        execute '!git cscope rebuild ' . a:exts
        call CscopeLoad(a:exts)
    endfunction

    command! CscopeLoad :call CscopeLoad(g:cscope_exts)
    command! CscopeRebuild :call CscopeRebuild(g:cscope_exts)
    CscopeLoad

	" 명령 결과를 quickfix 형태로
	set cscopequickfix=s-,t-

    set timeoutlen=4000
    set ttimeout
    set ttimeoutlen=100

    map <F5> :CscopeRebuild<CR>

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
"au! BufNewFile,BufRead *.php
autocmd BufRead,BufNewFile *.tpl    set filetype=php
autocmd FileType php                set iskeyword-=/ iskeyword+=$ matchpairs-=<:>

autocmd FileType dosini             set tabstop=8 softtabstop=0 shiftwidth=8 noexpandtab

" /etc/vimrc 에서 되돌리기
set nopaste

map <Leader>zo A<space>/*{{{*/<ESC>
map <Leader>zc A<space>/*}}}*/<ESC>

" silent explorer shortcut
map <Leader>e :silent! Explore<CR>

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
