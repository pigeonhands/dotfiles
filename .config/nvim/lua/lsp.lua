local cmp = require 'cmp'
local lspkind = require('lspkind')
cmp.setup({
	preselect = cmp.PreselectMode.None,
	-- Enable LSP snippets
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<Up>'] = cmp.mapping.select_prev_item(),
		['<Down>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		-- Add tab support
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		})
	},
	-- Installed sources:
	sources = {
		{ name = 'path' },                                 -- file paths
		{ name = 'nvim_lsp',               keyword_length = 3 }, -- from language server
		{ name = 'nvim_lsp_signature_help' },              -- display function signatures with current parameter emphasized
		{ name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
		{ name = 'buffer',                 keyword_length = 2 }, -- source current buffer
		{ name = 'vsnip',                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
		{ name = 'calc' },                                 -- source for math calculation
		{ name = 'nvim_lsp_signature_help' }
		-- { name = 'nvim_lsp_signature_help' },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = {
			-- 'menu' ]--,
			'abbr',
			'kind'
		},
		format = lspkind.cmp_format({
			mode = "symbol_text",
			menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
			})
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

local lsp_cmds = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
	group = lsp_cmds,
	desc = 'Lsp inlay hint attach',
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		vim.lsp.codelens.refresh()


		if client == nil then
			return
		end

		-- you can also put keymaps in here
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(bufnr, true)
		end
	end
})

vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
	group = lsp_cmds,
	desc = 'Lsp codelens refresh',
	callback = function(ev)
		vim.lsp.codelens.refresh()
	end
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup_handlers {
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {
			capabilities = capabilities
		}
	end,
	["rust_analyzer"] = function()
		-- Do not setup, handled by rustaceanvim
	end,
	['omnisharp'] = function()
		require 'lspconfig'.omnisharp.setup({
			capabilities = capabilities,
			-- capabilities = capabilities,
			-- on_attach = on_attach,
			enable_import_completion = true,
			organize_imports_on_format = true,
			enable_roslyn_analyzers = true,
		})
	end,
	["zls"] = function()
		local lsp = require('lspconfig')
		if vim.fn.has('win64') then
			lsp.zls.setup({
			capabilities = capabilities,
				zig_lib_path = "C:\\ProgramData\\chocolatey\\lib\zig\\tools\\zig-windows-x86_64-0.10.1\\lib"
			})
		else
			lsp.zls.setup({
			capabilities = capabilities,
				zig_lib_path = "/opt/zig/lib/"
			})
		end
	end,
	['pyright'] = function()
		require 'lspconfig'.pyright.setup({
			capabilities = capabilities,
			-- capabilities = capabilities,
			-- on_attach = on_attach,
			settings = {
				python = {
					pythonPath = "/usr/bin/python3"
				},
				pyright = {}
			}
		})
	end,
	['lua_ls'] = function()
		require 'lspconfig'.lua_ls.setup {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = 'LuaJIT',
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { 'vim' },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
					hint = {
						enable = true
					}
				},
			},

		}
	end
}

vim.g.rustaceanvim = function()
	local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
	local liblldb_path = extension_path .. 'lldb/lib/liblldb'
	local this_os = vim.uv.os_uname().sysname;
	local codelldb_path = extension_path .. 'adapter/codelldb'

	-- The path is different on Windows
	if this_os:find "Windows" then
		codelldb_path = extension_path .. "adapter\\codelldb.exe"
		liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
	else
		-- The liblldb extension is .so for Linux and .dylib for MacOS
		liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
	end

	local cfg = require('rustaceanvim.config')

	return {
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
				-- vim.lsp.inlay_hint.enable(bufnr, true)
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
			adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	}
end
