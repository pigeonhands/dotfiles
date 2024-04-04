-- Most keymaps are LazyVim defaults
-- http://www.lazyvim.org/keymaps

-- Ctrl + / clear search
vim.keymap.set("n", "<C-_>", ":noh<CR>")

-- Completion Plugin Setup
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

-- CodeLens
vim.keymap.set("n", "<leader>clld", vim.lsp.codelens.refresh)
vim.keymap.set("n", "<leader>clr", vim.lsp.codelens.run)

vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<CR>", { noremap = true })
-- vim.keymap.set("n", "<leader>fm", "<cmd>Neoformat<CR>" {noremap = true})

vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true })

-- move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- copy to clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("v", "<leader>y", '"+y')

--paste but retain buffer
vim.keymap.set("x", "<leader>p", '"_dP')

-- center cursor when jumping half page
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

-- center screen wwhen searching and unfold line (zv)
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
