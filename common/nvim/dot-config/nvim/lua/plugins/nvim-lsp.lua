return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason.nvim",
        "mason-org/mason-lspconfig.nvim",
    },
    opts = {
        -- All your diagnostic settings are preserved.
        diagnostics = {
            underline = true,
            update_in_insert = false,
            virtual_text = {
                spacing = 4,
                source = "if_many",
                prefix = "●",
            },
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "", -- Using Nerd Font icons directly
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.HINT] = "",
                    [vim.diagnostic.severity.INFO] = "",
                    -- [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
                    -- [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
                    -- [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
                    -- [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
                },
            },
        },
        inlay_hints = {
            enabled = true,
            exclude = { "vue", "python" },
        },
        codelens = {
            enabled = true,
        },
        document_highlight = {
            enabled = true,
        },
        ---@type lspconfig.options
        servers = {
            omnisharp = {
                cmd = {
                    "OmniSharp",
                    "-z",
                    "DotNet:enablePackageRestore=false",
                    "--encoding",
                    "utf-8",
                    "--languageserver",
                    "FormattingOptions:EnableEditorConfigSupport=true",
                    "Sdk:IncludePrereleases=true",
                    "--hostPID",
                    tostring(vim.fn.getpid()),
                },
            },

            -- ADD OTHER SERVERS HERE
            -- To have a server automatically installed and configured by mason-lspconfig,
            -- just add its name to this list with an empty table.
            -- Example:
            -- lua_ls = {},
            -- pyright = {},
            -- tsserver = {},
            -- denols = {},
            -- vtsls = {},
        },
    },
}
