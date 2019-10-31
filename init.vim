" -----------------------------------------------------------------------------
" Mics
" -----------------------------------------------------------------------------
set nu
set nowrap
set pastetoggle=<F10>
set hidden
set ignorecase
set smartcase
set viminfo='100,f1
se nostartofline
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

nnoremap <Leader>m :!markdown_previewer %<CR><CR>

" -----------------------------------------------------------------------------
" Mappings
" -----------------------------------------------------------------------------
noremap <Leader>w :w<CR>
noremap <Leader>q :q<CR>
noremap <Leader>y "+y
noremap <Leader>p "+p
inoremap kj <Esc>
vnoremap kj <Esc>

" Buffers
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-n> :enew<CR>
nnoremap <C-s> <C-w>v<C-w>l
nnoremap <C-o> <C-w>s<C-w>j
nnoremap <leader>l :b#<CR>
nnoremap <C-c> :bp\|bd #<CR>

" vim-unimpared stle, grab a line
noremap gy :<C-U>exe v:count . "y"<CR> <bar> :put<CR>
noremap gY :<C-U>exe v:count . "y"<CR> <bar> P<CR>

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
nnoremap , ;
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

" autoformatting
"--------------------------
Plug 'Chiel92/vim-autoformat'
let g:formatdef_custom_hindent = '"hindent --indent-size 4"'
let g:formatters_haskell = ['custom_hindent']
noremap <F3> :Autoformat<CR>

" Haskell
"--------------------------
" Can't get it to work with testing, just use ghcid extanally for now
"Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
" Should be fine as long as I always use stack
"let g:ghcid_command ="ghcid --test $':l test/Spec.hs \n main'"
"let g:ghcid_command ="stack ghci cis194:lib cis194:test:cis194-test --ghci-options=-fobject-code\" --test \"main"
"nnoremap <Leader>g :Ghcid<CR>

Plug 'itchyny/vim-haskell-indent'

" Text editing plugins
"--------------------------
Plug 'reedes/vim-pencil'
let g:pencil#wrapModeDefault = 'soft'
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd,text call pencil#init()
                            \ | setlocal spell spelllang=en_ca
                            \ | setlocal spell spelllang=en_ca
                            \ | syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell
augroup END
let g:extra_whitespace_ignored_filetypes = ['markdown']

" Python
"--------------------------
Plug 'psf/black'
nnoremap <F9> :Black<CR>
let g:black_fast = 1


" General plugins
"--------------------------

Plug 'rafi/awesome-vim-colorschemes'
Plug 'tpope/vim-sensible'
Plug 'Raimondi/delimitMate'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-unimpaired'
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
" Formatting
" -----------------------------------------------------------------------------
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set shiftround
