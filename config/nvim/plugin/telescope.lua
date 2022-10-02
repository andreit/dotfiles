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

vim.api.nvim_set_keymap('n', '<Leader>ff', '<Cmd>Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', '<Cmd>Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', '<Cmd>Telescope buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', '<Cmd>Telescope help_tags<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fl', '<Cmd>Telescope git_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fs', '<Cmd>Telescope lsp_document_symbols<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fw', '<Cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true })

