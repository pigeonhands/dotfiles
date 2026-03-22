return {
    "mistweaverco/kulala.nvim",
    ft = "",
    lazy = true,
    keys = {
        { "<leader>R",  "",                                            desc = "+Rest" },
        { "<leader>Rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open scratchpad" },
        { "<leader>Rz", "<cmd>lua require('kulala').search()<cr>",     desc = "Search",         ft = 'http' },
    },
}
