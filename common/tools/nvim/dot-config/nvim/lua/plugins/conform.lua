return {
    "stevearc/conform.nvim",
    -- optional = true,
    enabled = false,
    opts = {
        formatters_by_ft = {
            nix = { "nixfmt" },
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            python = { "isort", "black" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt", lsp_format = "fallback" },
        },
    },
}
