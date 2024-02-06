-- Completion Plugin Setup
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',  {  noremap = true, silent = true })
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>',  {  noremap = true, silent = true })
vim.keymap.set('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>',  {  noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", {noremap = true})

-- Diagnostics
vim.keymap.set('n', '<leader>ge', '<cmd>:Trouble<CR>', {  noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- CodeLens
vim.keymap.set('n', '<leader>clld', vim.lsp.codelens.refresh)
vim.keymap.set('n', '<leader>clr', vim.lsp.codelens.run)


local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.git_files, {})
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>ft', telescope.grep_string, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})
vim.keymap.set('n', '<leader>fr', telescope.lsp_references, {})
vim.keymap.set('n', '<leader>fs', telescope.treesitter, {})

-- Git
vim.keymap.set("n", "ggc", telescope.git_commits)
vim.keymap.set("n", "ggs", telescope.git_status)




vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>",{noremap = true})
-- vim.keymap.set("n", "<leader>fm", "<cmd>Neoformat<CR>" {noremap = true})

vim.keymap.set('n', '<leader>`', '<cmd>ToggleTerm<CR>', { noremap = true })
-- vim.keymap.set('t', '<leader>`', '<cmd>ToggleTerm<CR>', { noremap = true })
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { noremap = true })

-- move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- copy to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("v", "<leader>y", "\"+y")

--paste but retain buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- center cursor when jumping half page
vim.keymap.set('n', "<C-d>", "<C-d>zz", {noremap = true})
vim.keymap.set('n', "<C-u>", "<C-u>zz", {noremap = true})

-- center screen wwhen searching and unfold line (zv)
vim.keymap.set('n', "n", "nzzzv", {noremap = true})
vim.keymap.set('n', "N", "Nzzzv", {noremap = true})

----- barbar
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
 -- map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts) -- (use telescope instead)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
