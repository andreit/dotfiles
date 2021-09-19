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

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Bright theme with pastel 'retro groove' colors and light/dark mode
Plug 'morhetz/gruvbox'

" A light and configurable statusline
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
Plug 'tpope/vim-rhubarb'

" Kick off builds and test suites using one of several asynchronous adpters
Plug 'tpope/vim-dispatch'

" Shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" Highly extendable fuzzy finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Simple and easy way to use the interface for tree-sitter in Neovim and to 
" provide some basic functionality such as highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Comply with PEP8
Plug 'Vimjas/vim-python-pep8-indent'

" Wrapper for prettier, pre-configured with custom default prettier settings
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Preview markdown on your modern browser with synchronised scrolling and flexible configuration
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Go language support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Provides Rust file detection, syntax highlighting and formatting
Plug 'rust-lang/rust.vim'

" Common configurations for Neovim's built-in language server client
Plug 'neovim/nvim-lspconfig'

" Auto completion
Plug 'hrsh7th/nvim-compe'

" Snippets
Plug 'L3MON4D3/LuaSnip'

" Interactive scratchpad for lua
Plug 'rafcamlet/nvim-luapad'

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

" Customize colorcolumn colour
augroup colorcolumn_colors
  autocmd!
  autocmd ColorScheme * highlight ColorColumn ctermbg=0 guibg='#32302f'
augroup END

" Customize quick-scope colours
augroup quick_scope_colors
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

" Display a vertical ruler at column 80
set colorcolumn=80

" Highlight the screen line of the cursor
set cursorline

" In Insert mode, use the appropriate number of spaces to insert a <Tab>
set expandtab

" Hide buffer when abandoned
set hidden

" Show `▸▸` for tabs, `·` for tailing whitespace
set list listchars=tab:▸▸,trail:·,eol:$

" Print the line number in front of each line
set number

" Hide the current mode
set noshowmode

" Show the line number relative to the line with the cursor in front of each 
" line
set relativenumber

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=5

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
nnoremap <Leader>, :e $MYVIMRC<CR>
nnoremap <Leader>. :source $MYVIMRC<CR>

" Saving
inoremap <C-s> <C-O>:update<CR>
nnoremap <C-s> :update<CR>
nnoremap <Leader>s :update<CR>
nnoremap <Leader>w :update<CR>

" Quitting
inoremap <C-Q> <Esc>:q<CR>
nnoremap <C-Q> :q<CR>
vnoremap <C-Q> <Esc>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :qa!<CR>

" jk | Escaping!
inoremap jk <Esc>
" xnoremap jk <Esc>
cnoremap jk <C-c>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <Space> /
map <C-Space> ?
nnoremap <silent> <Leader><Space> :nohlsearch<CR>

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

" Qucikfix lists
nnoremap <Leader>lo :lopen<CR>
nnoremap <Leader>lc :lclose<CR>
nnoremap <Leader>co :copen<CR>
nnoremap <Leader>cc :cclose<CR>

" Quickly open the embedded Nvim terminal emulator
nnoremap <silent> <Leader>t :bel 10sp +terminal<CR>
"
" Enter terminal mode automatically
augroup term_open
  autocmd!
  autocmd TermOpen * startinsert
augroup END

" ############################################################################
" # lightline.vim                                                            #
" ############################################################################

let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \ },
  \ }

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
nnoremap <Leader>fs <Cmd>Telescope lsp_document_symbols<CR>
nnoremap <Leader>fw <Cmd>Telescope lsp_workspace_symbols<CR>

" ############################################################################
" # vim-dispatch                                                             #
" ############################################################################

" Makefile
nnoremap <Leader>mi :Make install<CR>
nnoremap <Leader>mt :Make test<CR>
nnoremap <Leader>ml :Make lint<CR>
nnoremap <Leader>mf :Make format<CR>
nnoremap <Leader>mr :Make run<CR>

" Yarn
nnoremap <Leader>yi :Dispatch yarn install<CR>
nnoremap <Leader>yt :Dispatch yarn test<CR>
nnoremap <Leader>ys :Dispatch! yarn start<CR>

" npm
nnoremap <Leader>ni :Dispatch npm install<CR>
nnoremap <Leader>nt :Dispatch npm test<CR>
nnoremap <Leader>ns :Dispatch npm start<CR>

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
local lsp = require'lsp'
lsp.setup()
EOF

" ############################################################################
" # completion.nvim                                                          #
" ############################################################################

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" ############################################################################
" # eslint_d                                                                 #
" ############################################################################

" Autofix entire buffer
nnoremap <Leader>be mF:%!eslint_d --stdin --fix-to-stdout<CR>`F

" Autofix visual selection
vnoremap <Leader>be :!eslint_d --stdin --fix-to-stdout<CR>gv

" ############################################################################
" # vim-prettier                                                             #
" ############################################################################

nmap <Leader>bp <Plug>(Prettier) <bar> <Cmd>e<CR>
 
let g:prettier#autoformat = 0
let g:prettier#exec_cmd_async = 1
