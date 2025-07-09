return {
    'olimorris/codecompanion.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        "j-hui/fidget.nvim",
        { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'codecompanion' } },
    },
    init = function()
        require("plugins.other.codecompanion-fidget"):init()
    end,
    config = function()
        vim.cmd([[cab cc CodeCompanion]])
        require('codecompanion').setup {
            strategies = {
                chat = {
                    adapter = 'gemini',
                },
                inline = {
                    adapter = 'gemini',
                },
            },
        }
    end,
    keys = {
        { mode = { "n", "v" }, "<localleader>a",             ":CodeCompanion<CR>",            desc = "ai generation",  { noremap = true } },
        { mode = { "n", "v" }, "<localleader><localleader>", ":CodeCompanionChat Toggle<CR>", desc = "ai chat",        { noremap = true } },
        { mode = { "n", "v" }, "<localleader>z",             ":CodeCompanionActions<CR>",     desc = "ai actions",     { noremap = true } },
    }
}
