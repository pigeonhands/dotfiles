return {
    "folke/snacks.nvim",
    keys = {
        { "<leader>.", function() Snacks.scratch({ ft = "markdown" }) end, desc = "Toggle Scratch Buffer" },
        { "<leader>S", function() Snacks.scratch.select() end,             desc = "Select Scratch Buffer" },
    }
};
