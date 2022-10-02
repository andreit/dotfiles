-- Use , as the <Leader> key
vim.g.mapleader = ","

require "globals.options"
require "globals.remaps"

require "plugins"

local lsp = require "lsp.lsp"

vim.cmd([[runtime! plugin/sensible.vim]])

-- Customize colorcolumn colour
vim.cmd([[
  augroup colorcolumn_colors
    autocmd!
    autocmd ColorScheme * highlight ColorColumn ctermbg=0 guibg='#32302f'
  augroup END
]])

vim.cmd([[
  augroup quick_scope_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
  augroup END
]])

vim.cmd([[
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
  augroup END
]])

lsp.setup()
