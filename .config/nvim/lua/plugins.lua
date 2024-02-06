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
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	'nvim-tree/nvim-web-devicons',
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
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
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = {
				view = "cmdline"
			},
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			{
				"rcarriga/nvim-notify",
				opts = {
					background_colour = "#000000"
				}
			},
		}
	},

	-- > code / LSP

	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		ft = { 'rust' },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			--`` { "lvimuser/lsp-inlayhints.nvim", opts = {} } ,
		},
		config = function()
			vim.g.rustaceanvim = {
				-- Plugin configuration
				tools = {
					hover_actions = {
						auto_focus = true,
					},
				},
				-- LSP configuration
				server = {
					on_attach = function(client, bufnr)
						-- you can also put keymaps in here
						vim.lsp.inlay_hint.enable(bufnr, true)
					end,
					settings = {
						-- rust-analyzer language server configuration
						['rust-analyzer'] = {
							assist = {
								importEnforceGranularity = true,
								importPrefix = 'crate',
							},
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								command = 'clippy',
							},
							inlayHints = { locationLinks = true },
							diagnostics = {
								enable = true,
								experimental = {
									enable = true,
								},
							},
						},
					},
				},
				-- DAP configuration
				dap = {
				},
			}
		end
	},
	{
		'saecki/crates.nvim',
		tag = 'stable',
		config = function()
			require('crates').setup()
		end,
	},
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


	"rafamadriz/friendly-snippets",
	'nvim-telescope/telescope-ui-select.nvim',
})

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true,   -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false,     -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
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
		dotfiles = false,
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
