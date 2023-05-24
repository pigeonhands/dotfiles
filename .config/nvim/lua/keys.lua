-- Completion Plugin Setup
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',  {  noremap = true, silent = true })
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>',  {  noremap = true, silent = true })
vim.keymap.set('n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<CR>',  {  noremap = true, silent = true })

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.git_files, {})
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})
vim.keymap.set('n', '<leader>fr', telescope.lsp_references, {})

vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",
                        {noremap = true})
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>",
                        {noremap = true})
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

-- search follows cursor
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

--paste but retain buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- center cursor when jumping half page
vim.keymap.set('n', "<C-d>", "<C-d>zz", {noremap = true})
vim.keymap.set('n', "<C-u>", "<C-u>zz", {noremap = true})

-- center screen wwhen searching and unfold line (zv)
vim.keymap.set('n', "n", "nzzzv", {noremap = true})
vim.keymap.set('n', "n", "Nzzzv", {noremap = true})

