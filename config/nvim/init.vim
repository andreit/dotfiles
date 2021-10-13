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

" Add icons to plugins
Plug 'ryanoasis/vim-devicons'

" A blazing fast and easy to configure neovim statusline written in pure lua
Plug 'hoob3rt/lualine.nvim'

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
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Simple and easy way to use the interface for tree-sitter in Neovim and to 
" provide some basic functionality such as highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Preview markdown on your modern browser with synchronised scrolling and flexible configuration
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Go language support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Provides Rust file detection, syntax highlighting and formatting
Plug 'rust-lang/rust.vim'

" Build flutter and dart applications in neovim using the native LSP
Plug 'akinsho/flutter-tools.nvim'

" Common configurations for Neovim's built-in language server client
Plug 'neovim/nvim-lspconfig'

" A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI
Plug 'glepnir/lspsaga.nvim'

" Auto completion
Plug 'hrsh7th/nvim-compe'

" Snippets
Plug 'L3MON4D3/LuaSnip'

" Interactive scratchpad for lua
Plug 'rafcamlet/nvim-luapad'

" The interactive scratchpad for hackers
Plug 'metakirby5/codi.vim'

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

" Configure the cursor style for each mode
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175

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

" Quickly open the embedded Nvim terminal emulator
nnoremap <silent> <Leader>t :bel 10sp +terminal<CR>
"
" Enter terminal mode automatically
augroup term_open
  autocmd!
  autocmd TermOpen * startinsert
augroup END

" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Find things with Telescope
nnoremap <Leader>ff <Cmd>Telescope find_files<CR>
nnoremap <Leader>fg <Cmd>Telescope live_grep<CR>
nnoremap <Leader>fb <Cmd>Telescope buffers<CR>
nnoremap <Leader>fh <Cmd>Telescope help_tags<CR>
nnoremap <Leader>fl <Cmd>Telescope git_files<CR>
nnoremap <Leader>fs <Cmd>Telescope lsp_document_symbols<CR>
nnoremap <Leader>fw <Cmd>Telescope lsp_workspace_symbols<CR>

lua << EOF
-- Setup lualine
local lualine = require "lualine"
lualine.setup{
  options = { 
    icons_enabled = false,
    section_separators = "", 
    component_separators = {"|", "|"} 
  },
  sections = {
    lualine_c = {
      "filename",
      {
        "diagnostics",
        sources = {"nvim_lsp"},
        symbols = {error = "E:", warn = "W:", info = "?:"},
      }
    }
  }
}

-- Setup telescope
local telescope = require "telescope"
telescope.setup{
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        height = 0.9,
        mirror = true,
        width = 0.8,
        preview_cutoff = 20,
      }
    }
  }
}
telescope.load_extension("fzf")

-- Setup nvim-treesitter
local nvim_treesitter_configs = require "nvim-treesitter.configs"
nvim_treesitter_configs.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true
  }
}

-- Setup built-in lsp client
local lsp = require "lsp"
lsp.setup()
EOF
