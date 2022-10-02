-- Use the system clipboard
vim.o.clipboard = "unnamed"

-- Number of screen lines to use for the command-line
vim.o.cmdheight = 2

-- - Use the popup menu also when there is only one match
-- - Do not insert any text for a match until the user selects 
--   a match from the menu
-- - Do not select a match in the menu, force the user to 
--   select one from the menu
vim.o.completeopt = "menuone,noinsert,noselect"

-- Display a vertical ruler at column 80
vim.o.colorcolumn = "80"

-- Highlight the screen line of the cursor
vim.o.cursorline = true

-- In Insert mode, use the appropriate number of spaces to insert a <Tab>
vim.o.expandtab = true

-- Configure the cursor style for each mode
vim.o.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Hide buffer when abandoned
vim.o.hidden = true

-- Show `▸▸` for tabs, `·` for tailing whitespace
vim.o.list = true
vim.o.listchars = "tab:▸▸,trail:·,eol:$"

-- Print the line number in front of each line
vim.o.number = true

-- Hide the current mode
vim.o.noshowmode = true

-- Show the line number relative to the line with the cursor in front of each line
vim.o.relativenumber = true

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 5

-- Number of spaces to use for each step of (auto)indent
vim.o.shiftwidth = 2

-- Don't give ins-completion-menu messages
vim.o.shortmess = vim.o.shortmess .. "c"

-- Always draw the signcolumn
vim.o.signcolumn = "yes"

-- Number of spaces that a <Tab> in the file counts for
vim.o.tabstop = 2

-- Write swapfile to disk if nothing is typed for 50 milliseconds
vim.o.updatetime = 50
