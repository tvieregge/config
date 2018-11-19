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
set viminfo='100,f1
noremap <F1> <ESC>
" This is needed for some reason
inoremap <F1> <ESC>
" This doesn't seem to work
let timeout = 100

let mapleader = " "
nnoremap <silent> <return> :nohls<return><esc>

" Marks should remember column by default
nnoremap ' `

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

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" -----------------------------------------------------------------------------
" Mappings
" -----------------------------------------------------------------------------
noremap <Leader>w :w<CR>
noremap <Leader>q :q<CR>
noremap <Leader>y "+y
noremap <Leader>p "+p
inoremap kj <Esc>
vnoremap kj <Esc>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-n> :enew<CR>
nnoremap <leader>s <C-w>v<C-w>l
nnoremap <leader>h <C-w>s<C-w>j

" -----------------------------------------------------------------------------
" Plugins 
" -----------------------------------------------------------------------------
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
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

let $FZF_DEFAULT_COMMAND = 'rg --files'
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

" vim-signify options
"--------------------------
Plug 'mhinz/vim-signify'
	" TODO: For some reason signify_cursorhold_insert and signify_cursorhold_normal
	"		aren't respected
	" let g:signify_realtime = 1
	" let g:signify_cursorhold_insert = 0
	" let g:signify_vcs_list = [ 'git' ]
	" let g:signify_cursorhold_normal = 0

Plug 'rafi/awesome-vim-colorschemes'
Plug 'tpope/vim-sensible'
Plug 'Raimondi/delimitMate'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
" Doesn't work, but looks really cool
"Plug 'shougo/echodoc.vim'

call plug#end()

" -----------------------------------------------------------------------------
" Visuals
" -----------------------------------------------------------------------------
hi CharLimit ctermfg=red guifg=red
match CharLimit /\%>79v.*\%<81v/
colorscheme onedark

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
