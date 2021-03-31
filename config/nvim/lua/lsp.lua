local lsp_status = require'lsp-status'
local completion = require'completion'
local lspconfig = require'lspconfig'

local severity_indicators = { 'E', 'W', 'i', '?' }
local servers = { "pyright", "tsserver", "graphql", "rust_analyzer", "gopls" }

local function on_attach(client, bufnr)
  lsp_status.on_attach(client)  
  completion.on_attach(client)

  local function buf_set_keymap(...) 
    vim.api.nvim_buf_set_keymap(bufnr, ...) 
  end
  
  local function buf_set_option(...) 
    vim.api.nvim_buf_set_option(bufnr, ...) 
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Define mappings
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

local function setup_servers()
  -- Use a loop to conveniently both setup defined servers 
  -- and map buffer local keybindings when the language server attaches
  for _, lsp in ipairs(servers) do
    local opts = { 
      on_attach = on_attach, 
      capabilities = lsp_status.capabilities
    }
    lspconfig[lsp].setup(opts)
  end
end

function handle_diagnostics_changed()
  local items = {}
  diagnostics = vim.lsp.diagnostic.get()
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(items, {
      filename = vim.fn.bufname(),
      type = severity_indicators[diagnostic.severity],
      lnum = diagnostic.range.start.line + 1,
      col = diagnostic.range.start.character + 1,
      text = diagnostic.message:gsub("\r", ""):gsub("\n", " ")
    })
  end
  vim.lsp.util.set_loclist(items)
  vim.api.nvim_command("doautocmd QuickFixCmdPost")
end

local function configure_lsp_status()
  lsp_status.register_progress()
  lsp_status.config({
    indicator_errors = severity_indicators[1],
    indicator_warnings = severity_indicators[2],
    indicator_info = severity_indicators[3],
    indicator_hint = severity_indicators[4],
    indicator_ok = 'Ok',
    status_symbol = ''
  })
end

local function setup()
  configure_lsp_status()
  setup_servers()
  vim.api.nvim_command [[
    autocmd! User LspDiagnosticsChanged lua handle_diagnostics_changed()
  ]]
end

local M = {
  setup = setup
}

return M
