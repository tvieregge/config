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

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
" Plug 'ray-x/go.nvim'
" " recommended if need floating window support
" Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
" Plug 'ray-x/navigator.lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'kevinhwang91/nvim-bqf'




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

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-unimpaired'
Plug 'ruanyl/vim-gh-line'
Plug 'mechatroner/rainbow_csv'
Plug 'mtdl9/vim-log-highlighting'

"Colorschemes
"--------------------------
Plug 'navarasu/onedark.nvim'
Plug 'savq/melange-nvim'
Plug 'cpea2506/one_monokai.nvim'
Plug 'mcchrish/zenbones.nvim'

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

lua <<EOF
require('onedark').setup {
    -- toggle theme style ---
    toggle_style_key = "<leader>ts",
    toggle_style_list = {'darker', 'warmer' }, -- List of styles to toggle between
    style = 'warmer'
}
require('onedark').load()
EOF

" -----------------------------------------------------------------------------
" Formatting
" -----------------------------------------------------------------------------
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set shiftround

lua require'lspconfig'.gopls.setup{}
lua vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
lua vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
lua vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
" lua vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

lua <<EOF
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    -- " vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

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
    --vim.keymap.set('n', '<space>f', function()
    --  vim.lsp.buf.format { async = true }
    --end, opts)
  end,
})

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      --['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  --[[
  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  --]]

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "sql", "python", "go", "rust", "javascript", "typescript" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  -- Tim: I don't, but lets see if it causes issues for now
  auto_install = true,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

EOF
