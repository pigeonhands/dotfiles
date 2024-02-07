return {
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				preselect = cmp.PreselectMode.None,
				-- Enable LSP snippets
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = {
					["<Up>"] = cmp.mapping.select_prev_item(),
					["<Down>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					-- Add tab support
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = false,
					}),
				},
				-- Installed sources:
				sources = {
					{ name = "path" }, -- file paths
					{ name = "nvim_lsp", keyword_length = 3 }, -- from language server
					{ name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
					{ name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
					{ name = "buffer", keyword_length = 2 }, -- source current buffer
					{ name = "vsnip", keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
					{ name = "calc" }, -- source for math calculation
					{ name = "nvim_lsp_signature_help" },
					-- { name = 'nvim_lsp_signature_help' },
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					fields = {
						-- 'menu' ]--,
						"abbr",
						"kind",
					},
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[Latex]",
						},
					}),

					--format = function(entry, item)
					--    local menu_icon ={
					--        nvim_lsp = 'λ',
					--        vsnip = '⋗',
					--        buffer = 'Ω',
					--        path = '🖫',
					--    }
					--    item.menu = menu_icon[entry.source.name]
					--    return item
					--end,
				},
			})
		end,
	},
	"onsails/lspkind.nvim",

	-- LSP completion source:
	"hrsh7th/cmp-nvim-lsp",

	-- Useful completion sources:
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/vim-vsnip",

	"rafamadriz/friendly-snippets",

	"hrsh7th/cmp-nvim-lsp-signature-help",
	--	{
	--		"ray-x/lsp_signature.nvim",
	--		event = "VeryLazy",
	--		enabled = false,
	--		opts = {},
	--		config = function(_, opts)
	--			require("lsp_signature").setup(opts)
	--		end,
	--	},
}
