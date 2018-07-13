set runtimepath^=~/.vim/bundle/ctrlp.vim
set number
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent
set textwidth=80
syntax on
nnoremap <F5> :buffers<CR>:buffer<Space>
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
call vundle#end()
filetype plugin indent on

