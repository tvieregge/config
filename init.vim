" -----------------------------------------------------------------------------
" Mics
" -----------------------------------------------------------------------------
set nu
set nowrap
set relativenumber
set pastetoggle=<F10>
set hidden
set ignorecase
set smartcase
noremap <F1> <ESC>

let mapleader = " "
nnoremap <silent> <return> :nohls<return><esc>

" Do things fast
noremap <Leader>w :w<CR>
noremap <Leader>q :q<CR>
noremap <Leader>y "+y
noremap <Leader>p "+p
inoremap jk <Esc>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>s <C-w>v<C-w>l
nnoremap <leader>h <C-w>s<C-w>j

" Move by screen line not file line (wordwrap)
nnoremap j gj
nnoremap k gk

" Hitting '%' is hard
nnoremap <tab> %
vnoremap <tab> %

" Search for highlighted, * and # for fwd/back search
function! s:getSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunction

vnoremap <silent> * :call setreg("/",
    \ substitute(<SID>getSelectedText(),
    \ '\_s\+',
    \ '\\_s\\+', 'g')
    \ )<Cr>n

vnoremap <silent> # :call setreg("?",
    \ substitute(<SID>getSelectedText(),
    \ '\_s\+',
    \ '\\_s\\+', 'g')
    \ )<Cr>n

" -----------------------------------------------------------------------------
" Plugins 
" -----------------------------------------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" fzf and related controles
"--------------------------
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Hide statusline in fzf
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let $FZF_DEFAULT_COMMAND = 'rg --hidden --exclude .git'
nnoremap ; :Buffers<CR>
nnoremap <Leader>t :Files<CR>
nnoremap <Leader>r :Tags<CR>
nnoremap <Leader>d :Rg<CR>
nnoremap <Leader>f :Rg <C-R><C-W><CR>

" NERDTree and controles
"--------------------------
Plug 'scrooloose/nerdtree'
let NERDTreeQuitOnOpen = 1
nnoremap <Leader>n :NERDTreeToggle<CR>

" Open NERDTree when vim open a dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

Plug 'tpope/vim-sensible'
Plug 'Raimondi/delimitMate'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'

" vim-signify options
"--------------------------
Plug 'mhinz/vim-signify'
let g:signify_realtime = 1
let g:signify_cursorhold_insert = 0
let g:signify_vcs_list = [ 'git' ]
let g:signify_cursorhold_insert = 0

call plug#end()

" -----------------------------------------------------------------------------
" Visuals
" -----------------------------------------------------------------------------
hi CharLimit ctermfg=red guifg=red
match CharLimit /\%>79v.*\%<81v/

" -----------------------------------------------------------------------------
"  Search
" -----------------------------------------------------------------------------
set grepprg=rg\ --vimgrep
nnoremap <Leader>g :silent lgrep<Space>

" -----------------------------------------------------------------------------
" Formatting
" -----------------------------------------------------------------------------
set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 
set shiftround
