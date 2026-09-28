return {
	"nvim.undotree",
	-- Tell lazy to look in Neovim's built-in runtime directory so it doesn't try to download it
	dir = vim.env.VIMRUNTIME .. "/pack/dist/opt/nvim.undotree",

	-- Lazy-load the plugin only when you press the shortcut key
	keys = {
		{
			"<leader>uu",
			function()
				-- You can use toggle(), open(), or close()
				require("undotree").open()
			end,
			desc = "Toggle Built-in Undotree",
		},
	},

	config = function()
		vim.opt.undofile = true
	end,
}
