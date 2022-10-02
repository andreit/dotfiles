-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- A port of gruvbox community theme to lua with treesitter support!
  use { "ellisonleao/gruvbox.nvim" }

  -- Universal set of defaults that (hopefully) everyone can agree on
  use 'tpope/vim-sensible'

  -- Pairs of handy bracket mappings
  use 'tpope/vim-unimpaired'

  -- A blazing fast and easy to configure neovim statusline written in pure lua
  use 'hoob3rt/lualine.nvim'

  -- Enhances netrw, partially in an attempt to mitigate the need for more 
  -- disruptive "project drawer" style plugins
  use 'tpope/vim-vinegar'

  -- Highlight for a unique character in every word on a line to help when using
  -- f and F
  use 'unblevable/quick-scope'

  -- Comment out and uncomment lines
  use 'tpope/vim-commentary'

  -- Easily delete, change and add parentheses, brackets, quotes, XML tags, etc.
  use 'tpope/vim-surround'

  -- Simplify your Git workflow
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'

  -- Highly extendable fuzzy finder
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use { 
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  -- Simple and easy way to use the interface for tree-sitter in Neovim and to 
  -- provide some basic functionality such as highlighting
  use { 
    'nvim-treesitter/nvim-treesitter', 
    run = ':TSUpdate' 
  }
  use 'nvim-treesitter/playground'

  -- Preview markdown on your modern browser with synchronised scrolling and flexible configuration
  use { 
    'iamcco/markdown-preview.nvim', 
    run = 'cd app && yarn install' 
  }

  -- Go language support
  use { 
    'fatih/vim-go', 
    run = ':GoUpdateBinaries' 
  }

  -- Provides Rust file detection, syntax highlighting and formatting
  use 'rust-lang/rust.vim'

  -- Build flutter and dart applications in neovim using the native LSP
  use 'akinsho/flutter-tools.nvim'

  -- Common configurations for Neovim's built-in language server client
  use 'neovim/nvim-lspconfig'

  -- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI
  use 'glepnir/lspsaga.nvim'

  -- Auto completion
  use 'hrsh7th/nvim-compe'

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  -- Interactive scratchpad for lua
  use 'rafcamlet/nvim-luapad'

  -- The interactive scratchpad for hackers
  use 'metakirby5/codi.vim'
end)
