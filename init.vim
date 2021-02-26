" Install vim-plug
let vim_plug_file = expand(stdpath('data') . '/site/autoload/plug.vim')
if has('win32') && !has('win64')
  let curl_exec = expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exec = expand('curl')
endif

if !filereadable(vim_plug_file)
  if !executable(curl_exec)
    echoerr "You have to either install curl or install vim-plug yourself!"
    execute "q!"
  endif

  echo "Installing vim-plug..."
  echo ""
  silent exec "!"curl_exec" -fLo " . shellescape(vim_plug_file) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

  autocmd VimEnter * PlugInstall
endif

" Use , as the <Leader> key
let mapleader = ","

" Enable embedded Lua script highlighting
let g:vimsyn_embed = 'l'

call plug#begin(stdpath('data') . '/plugged')

" Universal set of defaults that (hopefully) everyone can agree on
Plug 'tpope/vim-sensible'

" Bright theme with pastel 'retro groove' colors and light/dark mode
Plug 'morhetz/gruvbox'

" A light and configurable statusline/tabline
Plug 'itchyny/lightline.vim'

" Enhances netrw, partially in an attempt to mitigate the need for more 
" disruptive "project drawer" style plugins
Plug 'tpope/vim-vinegar'

" Highlight for a unique character in every word on a line to help when using
" f and F
Plug 'unblevable/quick-scope'

" Comment out and uncomment lines
Plug 'tpope/vim-commentary'

" Easily delete, change and add parentheses, brackets, quotes, XML tags, etc.
Plug 'tpope/vim-surround'

" Simplify your Git workflow
Plug 'tpope/vim-fugitive'

" Shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" Work with GitHub issues and PRs
Plug 'pwntester/octo.nvim'

" Highly extendable fuzzy finder.
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Simple and easy way to use the interface for tree-sitter in Neovim and to 
" provide some basic functionality such as highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Formatting code
Plug 'sbdchd/neoformat'

" Comply with PEP8
Plug 'Vimjas/vim-python-pep8-indent'

" Go language support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Provides Rust file detection, syntax highlighting and formatting
Plug 'rust-lang/rust.vim'

" Common configurations for Neovim's built-in language server client
Plug 'neovim/nvim-lspconfig'

" Auto completion framework that aims to provide a better completion 
" experience with neovim's built-in LSP
Plug 'nvim-lua/completion-nvim'

" Neovim plugin/library for generating statusline components from the built-in 
" LSP client
Plug 'nvim-lua/lsp-status.nvim'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

runtime! plugin/sensible.vim

" Enable 24-bit RGB color
if has('termguicolors')
  set termguicolors
endif

" Customize quick-scope colours
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

colorscheme gruvbox

" Use the system clipboard
set clipboard=unnamed

" Number of screen lines to use for the command-line
set cmdheight=2

" - Use the popup menu also when there is only one match
" - Do not insert any text for a match until the user selects 
"   a match from the menu
" - Do not select a match in the menu, force the user to 
"   select one from the menu
set completeopt=menuone,noinsert,noselect

" Highlight the screen line of the cursor
set cursorline

" In Insert mode, use the appropriate number of spaces to insert a <Tab>
set expandtab

" Hide buffer when abandoned
set hidden

" Show `▸▸` for tabs, `·` for tailing whitespace
set list listchars=tab:▸▸,trail:·

" Enable mouse mode
set mouse=a

" Hide the current mode
set noshowmode

" Print the line number in front of each line
set number

" Show the line number relative to the line with the cursor in front of each 
" line
set relativenumber

" Number of spaces to use for each step of (auto)indent
set shiftwidth=2

" Don't give ins-completion-menu messages
set shortmess+=c

" Always draw the signcolumn
set signcolumn=yes

" Number of spaces that a <Tab> in the file counts for
set tabstop=2

" Write swapfile to disk if nothing is typed for 50 milliseconds
set updatetime=50

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" Fast editing and reloading of config
nnoremap <Leader>, :vsplit $MYVIMRC<CR>
nnoremap <Leader>. :source $MYVIMRC<CR>

" Another way to exit insert mode
inoremap jk <Esc>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <Space> /
map <C-Space> ?

" Use arrow keys to move between windows
map <Down> <C-w>j
map <Up> <C-w>k
map <Left> <C-w>h
map <Right> <C-w>l

" Move lines by holding down Shift and using the arrow keys
nnoremap <silent> <S-Up> :move-2<CR>
nnoremap <silent> <S-Down> :move+<CR>
nnoremap <silent> <S-Left> <<
nnoremap <silent> <S-Right> >>
xnoremap <silent> <S-Up> :move-2<CR>gv
xnoremap <silent> <S-Down> :move'>+<CR>gv
xnoremap <silent> <S-Left> <gv
xnoremap <silent> <S-Right> >gv
xnoremap < <gv
xnoremap > >gv

" Pressing <Leader>ss will toggle and untoggle spell checking
map <Leader>ss :setlocal spell!<CR>


" ############################################################################
" # lightline.vim                                                            #
" ############################################################################

let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified', 'lspstatus' ] ]
  \ },
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \   'gitbranch': 'FugitiveHead',
  \   'lspstatus': 'LspStatus'
  \ }
  \ }

function! LightlineFilename()
    return expand('%')
endfunction

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return trim(luaeval('require("lsp-status").status()'))
  endif

  return ''
endfunction

" ############################################################################
" # quick-scope                                                              #
" ############################################################################

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ############################################################################
" # telescope.nvim                                                           #
" ############################################################################

nnoremap <Leader>ff <Cmd>Telescope find_files<CR>
nnoremap <Leader>fg <Cmd>Telescope live_grep<CR>
nnoremap <Leader>fb <Cmd>Telescope buffers<CR>
nnoremap <Leader>fh <Cmd>Telescope help_tags<CR>
nnoremap <Leader>fl <Cmd>Telescope git_files<CR>

" ############################################################################
" # octo.nvim                                                                #
" ############################################################################

lua << EOF
require'telescope'.load_extension'octo'
EOF

" ############################################################################
" # nvim-treesitter                                                          #
" ############################################################################

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true
  }
}
EOF

" ############################################################################
" # LSP                                                                      #
" ############################################################################

lua << EOF
local lsp_status = require'lsp-status'
lsp_status.register_progress()
lsp_status.config({
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'i',
  indicator_hint = '?',
  indicator_ok = 'Ok',
  status_symbol = ''
})

local completion = require'completion'

local lspconfig = require'lspconfig'
local on_attach = function(client, bufnr)
  lsp_status.on_attach(client)  
  completion.on_attach(client)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<Leader>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>q', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<Leader>f", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guifg=#f2e5bc guibg=#af3a03
      hi LspReferenceText cterm=bold ctermbg=red guifg=#f2e5bc guibg=#af3a03
      hi LspReferenceWrite cterm=bold ctermbg=red guifg=#f2e5bc guibg=#af3a03
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyls", "tsserver", "graphql", "rust_analyzer", "gopls" }
for _, lsp in ipairs(servers) do
  local opts = { 
    on_attach = on_attach, 
    capabilities = lsp_status.capabilities 
  }
  if lsp == "pyls" then
    opts["settings"] = {
      configurationSources = {"flake8"}
    }
  end
  lspconfig[lsp].setup(opts)
end
EOF

" ############################################################################
" # completion.nvim                                                          #
" ############################################################################

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
