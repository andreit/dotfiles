local nvim_treesitter_configs = require "nvim-treesitter.configs"
nvim_treesitter_configs.setup {
  ensure_installed = "all",
  highlight = {
    enable = true
  }
}
