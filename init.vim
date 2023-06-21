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
" nnoremap <tab> %
" vnoremap <tab> %

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
" inoremap kj <Esc> " cause an annoyin pause when hitting 'k', not needed
" vnoremap kj <Esc>

" Buffers
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-n> :enew<CR>
nnoremap <C-s> <C-w>v<C-w>l
nnoremap <C-a> <C-w>s<C-w>j
nnoremap <leader>l :b#<CR>
nnoremap <C-c> :bp\|bd #<CR>

" vim-unimpared stle, grab a line
" currently overriden by coc
" noremap gy :<C-U>exe v:count . "y"<CR> <bar> :put<CR>
" noremap gY :<C-U>exe v:count . "y"<CR> <bar> P<CR>

:nnoremap date "=strftime("%c")<CR>p
" :inoremap date <C-R>=strftime("%c")<CR>

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
" nnoremap <Leader>r :Tags<CR>
nnoremap <Leader>d :Rg<CR>
nnoremap <Leader>f :Rg <C-R><C-W><CR>

" vim-signify options
"--------------------------
Plug 'mhinz/vim-signify'
	" TODO: For some reason signify_cursorhold_insert and signify_cursorhold_normal
	"		aren't respected
	" let g:signify_realtime = 1
	" let g:signify_cursorhold_insert = 0
	" let g:signify_vcs_list = [ 'git' ]
	" let g:signify_cursorhold_normal = 0


" autocomplete
"--------------------------
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" set updatetime=100

" " Use tab for trigger completion with characters ahead and navigate.
" " NOTE: There's always complete item selected by default, you may want to enable
" " no select by `"suggest.noselect": true` in your configuration file.
" " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#pum#next(1) :
"       \ CheckBackspace() ? "\<Tab>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" " Make <CR> to accept selected completion item or notify coc.nvim to format
" " <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" function! CheckBackspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" " Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Haskell
"--------------------------
" Can't get it to work with testing, just use ghcid extanally for now
"Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
" Should be fine as long as I always use stack
"let g:ghcid_command ="ghcid --test $':l test/Spec.hs \n main'"
"let g:ghcid_command ="stack ghci cis194:lib cis194:test:cis194-test --ghci-options=-fobject-code\" --test \"main"
"nnoremap <Leader>g :Ghcid<CR>

" Plug 'itchyny/vim-haskell-indent'
" Plug 'Chiel92/vim-autoformat'
" let g:formatdef_custom_hindent = '"hindent --indent-size 4"'
" let g:formatters_haskell = ['custom_hindent']
" noremap <F3> :Autoformat<CR>

" Text editing plugins
"--------------------------
Plug 'reedes/vim-pencil'
let g:pencil#wrapModeDefault = 'soft'
augroup pencil
  autocmd!
  autocmd FileType rst,markdown,mkd,text call pencil#init()
                            \ | setlocal spell spelllang=en_ca
                            \ | setlocal spell spelllang=en_ca
                            \ | syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell
augroup END
let g:extra_whitespace_ignored_filetypes = ['markdown']

" Python
"--------------------------
" Plug 'psf/black', { 'tag': '19.10b0' }
" nnoremap <F9> :Black<CR>
" let g:black_fast = 1
" autocmd BufWritePre *.py execute ':Black'

Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }


" Ranger integration
"--------------------------
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim' " dependency for ranger.vim

let g:ranger_map_keys = 0
map <leader>r :Ranger<CR>

let g:ranger_replace_netrw = 1 " open ranger when vim open a directory
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'

" Golang
"--------------------------
" Plug 'fatih/vim-go'
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
" let g:go_def_mapping_enabled = 0
" let g:go_fmt_command = "goimports"

" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
" Plug 'ray-x/go.nvim'
" " recommended if need floating window support
" Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
" Plug 'ray-x/navigator.lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'




" C
"--------------------------
Plug 'rhysd/vim-clang-format'
let g:clang_format#style_options = {
    \ "BasedOnStyle" : "mozilla",
    \ "IndentWidth" : "4",
    \ "ColumnLimit" : "100" }

autocmd FileType c,cpp,objc  ClangFormatAutoEnable

" Basic languare support
"--------------------------
" Plug 'sheerun/vim-polyglot'
Plug 'hashivim/vim-terraform'
" Plug 'jvirtanen/vim-hcl'
let g:terraform_fmt_on_save = 1

" General plugins
"--------------------------

" Autorun
" Plug 'neomake/neomake'

Plug 'rafi/awesome-vim-colorschemes'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-unimpaired'
Plug 'ruanyl/vim-gh-line'
Plug 'mechatroner/rainbow_csv'
Plug 'mtdl9/vim-log-highlighting'

call plug#end()


" Pretty sure this is entirely superseded by coc-jedi
" Neomake
"--------------------------

 " When writing a buffer (no delay), and on normal mode changes (after 30s).
 " call neomake#configure#automake('nw', 30000)

 " Pylint
 let g:neomake_python_pylint_maker = {
   \ 'args': [
   \ '-d', 'C0330',
   \ '-f', 'text',
   \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
   \ '-r', 'n'
   \ ],
   \ 'errorformat':
   \ '%A%f:%l:%c:%t: %m,' .
   \ '%A%f:%l: %m,' .
   \ '%A%f:(%l): %m,' .
   \ '%-Z%p^%.%#,' .
   \ '%-G%.%#',
   \ }

 let g:neomake_python_enabled_makers = ['pylint']


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

lua require'lspconfig'.gopls.setup{}
lua vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
lua vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
lua vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
lua vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

lua <<EOF
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF
