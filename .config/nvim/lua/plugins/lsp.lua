return {

	"williamboman/mason.nvim",
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["rust_analyzer"] = function()
					-- Do not setup, handled by rustaceanvim
				end,
				["omnisharp"] = function()
					require("lspconfig").omnisharp.setup({
						capabilities = capabilities,
						-- capabilities = capabilities,
						-- on_attach = on_attach,
						enable_import_completion = true,
						organize_imports_on_format = true,
						enable_roslyn_analyzers = true,
					})
				end,
				["zls"] = function()
					local lsp = require("lspconfig")
					if vim.fn.has("win64") then
						lsp.zls.setup({
							capabilities = capabilities,
							zig_lib_path = "C:\\ProgramData\\chocolatey\\lib\zig\\tools\\zig-windows-x86_64-0.10.1\\lib",
						})
					else
						lsp.zls.setup({
							capabilities = capabilities,
							zig_lib_path = "/opt/zig/lib/",
						})
					end
				end,
				["pyright"] = function()
					require("lspconfig").pyright.setup({
						capabilities = capabilities,
						-- capabilities = capabilities,
						-- on_attach = on_attach,
						settings = {
							python = {
								pythonPath = "/usr/bin/python3",
							},
							pyright = {},
						},
					})
				end,
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = {
									-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
									version = "LuaJIT",
								},
								diagnostics = {
									-- Get the language server to recognize the `vim` global
									globals = { "vim" },
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
									enable = true,
								},
							},
						},
					})
				end,
			})
		end,
	},

	"neovim/nvim-lspconfig",
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			--`` { "lvimuser/lsp-inlayhints.nvim", opts = {} } ,
		},
		config = function()
			vim.g.rustaceanvim = function()
				local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
				local liblldb_path = extension_path .. "lldb/lib/liblldb"
				local this_os = vim.uv.os_uname().sysname
				local codelldb_path = extension_path .. "adapter/codelldb"

				-- The path is different on Windows
				if this_os:find("Windows") then
					codelldb_path = extension_path .. "adapter\\codelldb.exe"
					liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
				else
					-- The liblldb extension is .so for Linux and .dylib for MacOS
					liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
				end

				local cfg = require("rustaceanvim.config")

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
							["rust-analyzer"] = {
								assist = {
									importEnforceGranularity = true,
									importPrefix = "crate",
								},
								cargo = {
									allFeatures = true,
								},
								checkOnSave = {
									command = "clippy",
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
		end,
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup()
		end,
	},
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
}
