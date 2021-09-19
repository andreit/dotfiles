local nvim_lsp = require('lspconfig')

local function on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  if client.name == "efm" then
      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.goto_definition = false
  elseif client.name == "tsserver" then
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
  end
  
  -- Enable completion triggered by <C-x><C-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
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
  buf_set_keymap('n', '<Leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>l', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keymaps conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<Leader>bf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
end

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

local function lsp_setup()
  vim.lsp.set_log_level("debug")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local servers = { 
    "pyright", 
    "tsserver", 
    "omnisharp",
    "graphql", 
    "rust_analyzer", 
    "gopls",
    "sumneko_lua",
    "efm",
    "html"
  }
  for _, lsp in ipairs(servers) do
    local opts = {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = capabilities,
    }

    if lsp == "omnisharp" then
      local pid = vim.fn.getpid()
      local omnisharp_bin = vim.fn.stdpath('cache')..'/omnisharp-osx/run'
      opts.cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
    elseif lsp == "sumneko_lua" then
      local system_name
      if vim.fn.has("mac") == 1 then
        system_name = "macOS"
      elseif vim.fn.has("unix") == 1 then
        system_name = "Linux"
      elseif vim.fn.has('win32') == 1 then
        system_name = "Windows"
      else
        print("Unsupported system for sumneko!")
      end

      local sumneko_root_path = vim.fn.stdpath('cache')..'/lua-language-server'
      local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      opts.cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" };
      opts.settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      }
    elseif lsp == "efm" then
      opts.root_dir = function()
        if not eslint_config_exists() then
          return nil
        end
        return vim.fn.getcwd()
      end

      opts.init_options = { documentFormatting = true }

      local eslint = {
        lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
        lintStdin = true,
        lintFormats = {"%f:%l:%c: %m"},
        lintIgnoreExitCode = true,
        formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
        formatStdin = true
      }
      opts.settings = {
        languages = {
          javascript = {eslint},
          javascriptreact = {eslint},
          ["javascript.jsx"] = {eslint},
          typescript = {eslint},
          ["typescript.tsx"] = {eslint},
          typescriptreact = {eslint}
        }
      }

      opts.filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescript.tsx",
        "typescriptreact"
      }
    end

    nvim_lsp[lsp].setup(opts)
  end
end

local function autocompletion_setup()
  -- Set completeopt to have a better completion experience
  -- vim.o.completeopt = 'menuone,noinsert'

  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
      path = true;
      nvim_lsp = true;
      luasnip = true,
      buffer = true,
      calc = false,
      nvim_lua = false,
      vsnip = false,
      ultisnips = false,
    };
  }

  -- Utility functions for compe and luasnip
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
      local col = vim.fn.col('.') - 1
      if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          return true
      else
          return false
      end
  end

  -- Use (s-)tab to:
  --- move to prev/next item in completion menu
  --- jump to prev/next snippet's placeholder
  local luasnip = require'luasnip'

  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t '<C-n>'
    elseif luasnip.expand_or_jumpable() then
      return t '<Plug>luasnip-expand-or-jump'
    elseif check_back_space() then
      return t '<Tab>'
    else
      return vim.fn['compe#complete']()
    end
  end

  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t '<C-p>'
    elseif luasnip.jumpable(-1) then
      return t '<Plug>luasnip-jump-prev'
    else
      return t '<S-Tab>'
    end
  end

  -- Map tab to the above tab complete functions
  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

  -- Map compe confirm and complete functions
  vim.api.nvim_set_keymap('i', '<CR>', 'compe#confirm("<CR>")', { expr = true })
  vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', { expr = true })
end

local function setup()
  lsp_setup()
  autocompletion_setup()
end

local M = {
  setup = setup
}

return M
