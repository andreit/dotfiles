" Use , as the <Leader> key
let mapleader = ","

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

" General-purpose command-line fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Comment out and uncomment lines
Plug 'tpope/vim-commentary'

" Easily delete, change and add parentheses, brackets, quotes, XML tags, etc.
Plug 'tpope/vim-surround'

" Simplify your Git workflow
Plug 'tpope/vim-fugitive'

" Shows a git diff in the sign column
Plug 'airblade/vim-gitgutter'

" Semantic highlighting for Python
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" Modify indentation behavior to comply with PEP8
Plug 'Vimjas/vim-python-pep8-indent'

" Syntax highlighting and improved indentation for JavaScript
Plug 'pangloss/vim-javascript'

" Syntax, file and other settings for TypeScript
Plug 'leafgarland/typescript-vim'

" React syntax highlighting and indenting
Plug 'maxmellon/vim-jsx-pretty'

" GraphQL file detection, syntax highlighting, and indentation
Plug 'jparise/vim-graphql'

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

runtime! plugin/sensible.vim

" Use the system clipboard
set clipboard=unnamed

" Enable 24-bit RGB color
set termguicolors
colorscheme gruvbox

" Highlight the screen line of the cursor
set cursorline

" Use a color column on the 80-character mark
set colorcolumn=80

" Hide buffer when abandoned
set hidden

" Print the line number in front of each line
set number

" Show the line number relative to the line with the cursor in front of each 
" line
set relativenumber

" Always draw the signcolumn
set signcolumn=yes

" Number of spaces that a <Tab> in the file counts for
set tabstop=2

" Number of spaces to use for each step of (auto)indent
set shiftwidth=2

" In Insert mode, use the appropriate number of spaces to insert a <Tab>
set expandtab 

" Show `▸▸` for tabs, `·` for tailing whitespace
set list listchars=tab:▸▸,trail:·

" Enable mouse mode
set mouse=a

" Hide the current mode as it is displayed by the lightline plugin
set noshowmode

" Write swapfile to disk if nothing is typed for 300 milliseconds
set updatetime=300

" Fast editing and reloading of config
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

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

"
" lightline configuration
"
let g:lightline = {
  \ 'component_function': {
  \   'filename': 'LightlineFilename'
  \ }
  \ }

function! LightlineFilename()
    return expand('%')
endfunction

"
" FZF configuration
"
let $FZF_DEFAULT_OPTS .= ' --inline-info'

" All files
command! -nargs=? -complete=dir AF
  \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
  \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
  \ })))

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif

nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <Leader><Enter> :Buffers<CR>
nnoremap <silent> <Leader>. :Rg<CR>
nnoremap <silent> <Leader>/ :Lines<CR>

"
" completion-nvim configuration
"

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

"
" LSP setup
"
lua << EOF
local lspconfig = require'lspconfig'
local completion = require'completion'

lspconfig.pyls.setup{
  settings = {
    configurationSources = {"flake8"}
  },
  on_attach = completion.on_attach
}
EOF

