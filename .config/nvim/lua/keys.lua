
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', telescope.git_files, {})
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",
                        {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>NvimTreeToggle<CR>",
                        {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>Neoformat<CR>",
                        {noremap = true})
