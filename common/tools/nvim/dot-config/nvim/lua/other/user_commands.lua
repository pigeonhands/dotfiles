vim.api.nvim_create_user_command("CleanUndo", function()
	-- Dynamically get the correct undo path for your OS (usually ~/.local/state/nvim/undo)
	local undo_dir = vim.fn.stdpath("state") .. "/undo"

	if vim.fn.isdirectory(undo_dir) == 1 then
		-- Recursively delete the folder and its contents
		vim.fn.delete(undo_dir, "rf")
		-- Recreate the empty folder so Neovim can continue saving new undos
		vim.fn.mkdir(undo_dir, "p")
		vim.notify("Undo directory cleared successfully!", vim.log.levels.INFO)
	else
		vim.notify("Undo directory not found or already empty.", vim.log.levels.WARN)
	end
end, { desc = "Clear all persistent undo files" })
