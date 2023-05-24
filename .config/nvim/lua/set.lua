vim.g.mapleader = " "

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.wrap = false

vim.opt.relativenumber = true
vim.opt.nu = true
vim.opt.termguicolors = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
-- Ctrl + / clear search
vim.keymap.set("n", "<C-_>", ":noh<CR>")
vim.opt.scrolloff = 8

-- for nerdtree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

