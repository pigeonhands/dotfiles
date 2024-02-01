local cmp = require'cmp'
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
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
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


require("mason-lspconfig").setup_handlers {
	function (server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
	["rust_analyzer"] = function ()
    -- Do not setup, handled by rustaceanvim
	end,
	["zls"] = function ()
    local lsp = require('lspconfig')
    if vim.fn.has('win64') then
      lsp.zls.setup ({
        zig_lib_path = "C:\\ProgramData\\chocolatey\\lib\zig\\tools\\zig-windows-x86_64-0.10.1\\lib"	
      })
    else
      lsp.zls.setup ({
        zig_lib_path = "/opt/zig/lib/"	
      })
    end
	end,
	['pyright'] = function()
		require'lspconfig'.pyright.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings={
				python = {
					pythonPath="/usr/bin/python3"
				},
				pyright = {}
			}
		})
	end,
	['lua_ls'] = function() 
		require'lspconfig'.lua_ls.setup {
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = 'LuaJIT',
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = {'vim'},
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},

		}
	end
}

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
  },
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      -- you can also put keymaps in here
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