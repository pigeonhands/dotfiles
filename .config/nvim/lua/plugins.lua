local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'wbthomason/packer.nvim',
	-- > theme
	{ 'rose-pine/neovim',           as = 'rose-pine' },
	{ 'projekt0n/github-nvim-theme' },

	-- > fucntionality
	'lewis6991/gitsigns.nvim',
	'nvim-tree/nvim-tree.lua',
	'nvim-tree/nvim-web-devicons',
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	},
	'windwp/nvim-autopairs',
	"akinsho/toggleterm.nvim",

	--> ui
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
	},
	'RRethy/vim-illuminate',
	'goolord/alpha-nvim',
	'folke/which-key.nvim',
	'xiyaowong/transparent.nvim',

	-- > code / LSP

	-- 'sbdchd/neoformat',
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	{ 'nvim-treesitter/nvim-treesitter',        run = { ":TSUpdate" } },
	{ 'nvim-treesitter/nvim-treesitter-context' },

	-- Completion framework:
	'hrsh7th/nvim-cmp',
	'onsails/lspkind.nvim',

	-- LSP completion source:
	'hrsh7th/cmp-nvim-lsp',

	-- Useful completion sources:
	'hrsh7th/cmp-nvim-lua',
	'hrsh7th/cmp-nvim-lsp-signature-help',
	'hrsh7th/cmp-vsnip',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-buffer',
	'hrsh7th/vim-vsnip',

	'simrat39/rust-tools.nvim',

	"rafamadriz/friendly-snippets",
	'nvim-telescope/telescope-ui-select.nvim',
})

require("mason").setup()
require("mason-lspconfig").setup()

require('gitsigns').setup {
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
		delay = 500,
		ignore_whitespace = false,
	},
}


-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})
require 'treesitter-context'.setup {
}

require('lualine').setup()
require('nvim-autopairs').setup()

require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
require("which-key").setup()
vim.o.timeout = true
vim.o.timeoutlen = 500

require("toggleterm").setup()

require("telescope").load_extension("ui-select")
