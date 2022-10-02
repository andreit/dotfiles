options = { noremap = true }

-- Fast editing and reloading of config
vim.api.nvim_set_keymap('n', '<Leader>,', ':e $MYVIMRC<CR>', options)
vim.api.nvim_set_keymap('n', '<Leader>.', ':source $MYVIMRC<CR>', options)

-- Saving
vim.api.nvim_set_keymap('i', '<C-s>', '<C-O>:update<CR>', options)
vim.api.nvim_set_keymap('n', '<C-s>', ':update<CR>', options)
vim.api.nvim_set_keymap('n', '<Leader>s', ':update<CR>', options)
vim.api.nvim_set_keymap('n', '<Leader>w', ':update<CR>', options)

-- Quitting
vim.api.nvim_set_keymap('i', '<C-Q>', '<Esc>:q<CR>', options)
vim.api.nvim_set_keymap('n', '<C-Q>', ':q<CR>', options)
vim.api.nvim_set_keymap('v', '<C-Q>', '<Esc>', options)
vim.api.nvim_set_keymap('n', '<Leader>q', ':q<CR>', options)
vim.api.nvim_set_keymap('n', '<Leader>Q', ':qa!<CR>', options)

-- jk | Escaping!
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', options)
vim.api.nvim_set_keymap('x', 'jk', '<Esc>', options)
vim.api.nvim_set_keymap('c', 'jk', '<C-c>', options)

-- Movement in insert mode
vim.api.nvim_set_keymap('i', 'C-h', '<C-o>h', options)
vim.api.nvim_set_keymap('i', 'C-l', '<C-o>a', options)
vim.api.nvim_set_keymap('i', 'C-j', '<C-o>j', options)
vim.api.nvim_set_keymap('i', 'C-k', '<C-o>k', options)
vim.api.nvim_set_keymap('i', 'C-^', '<C-o><C-^>', options)

-- Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
vim.api.nvim_set_keymap('', '<Space>', '/', {})
vim.api.nvim_set_keymap('', '<C-Space>', '?', {})
vim.api.nvim_set_keymap('n', '<Leader><Space>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Use arrow keys to move between windows
vim.api.nvim_set_keymap('', '<Down>', '<C-w>j', {})
vim.api.nvim_set_keymap('', '<Up>', '<C-w>k', {})
vim.api.nvim_set_keymap('', '<Left>', '<C-w>h', {})
vim.api.nvim_set_keymap('', '<Right>', '<C-w>l', {})

-- Move lines by holding down Shift and using the arrow keys
vim.api.nvim_set_keymap('n', '<S-Up>', ':move-2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Down>', ':move+<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Left>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Right>', '>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<S-Up>', ':move-2<CR>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<S-Down>', ":move'>+<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<S-Left>', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<S-Right>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<', '<gv', options)
vim.api.nvim_set_keymap('x', '>', '>gv', options)

-- Pressing <Leader>ss will toggle and untoggle spell checking
vim.api.nvim_set_keymap('', '<Leader>ss', ':setlocal spell!<CR>', {})

-- Quickly open the embedded Nvim terminal emulator
vim.api.nvim_set_keymap('n', '<Leader>t', ':bel 10sp +terminal<CR>', { noremap = true, silent = true })

-- Enter terminal mode automatically
vim.cmd([[
  augroup term_open
    autocmd!
    autocmd TermOpen * startinsert
  augroup END
]])

