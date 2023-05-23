-- Completion Plugin Setup
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',  {  noremap = true, silent = true })

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.git_files, {})
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",
                        {noremap = true})
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>",
                        {noremap = true})
vim.keymap.set("n", "<leader>fm", "<cmd>Neoformat<CR>",
                        {noremap = true})

vim.keymap.set('n', '<leader>`', '<cmd>ToggleTerm<CR>', { noremap = true })
-- vim.keymap.set('t', '<leader>`', '<cmd>ToggleTerm<CR>', { noremap = true })
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { noremap = true })
