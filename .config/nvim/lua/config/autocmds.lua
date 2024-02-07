
local lsp_cmds = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
	group = lsp_cmds,
	desc = 'Lsp inlay hint attach',
	callback = function(event)
		local bufnr = event.buf
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		vim.lsp.codelens.refresh()


		if client == nil then
			return
		end

		-- you can also put keymaps in here
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(bufnr, true)
		end
	end
})

vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
	group = lsp_cmds,
	desc = 'Lsp codelens refresh',
	callback = function(ev)
		vim.lsp.codelens.refresh()
	end
})
