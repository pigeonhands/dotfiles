return {
    {
        "folke/flash.nvim",
        enabled = true,
        keys = {
            { "s",     mode = { "n", "x", "o" }, false },
            { "S",     mode = { "n", "x", "o" }, false },
            { "r",     mode = "o",               false },
            { "R",     mode = { "o", "x" },      false },
            { "<c-s>", mode = { "c" },           false },
            {
                "<leader>sfs",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "<leader>sfS",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "<leader>sfr",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "<leader>sfR",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
}
