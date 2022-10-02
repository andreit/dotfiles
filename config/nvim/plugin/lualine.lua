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
