vim.filetype.add({ extension = { xur = "xur" } })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "xur",
  callback = function(ev)
    vim.lsp.start({
      name = "xur",
      cmd = { "xur", "lsp" },
      root_dir = vim.fs.root(ev.buf, "main.xur") or vim.fn.getcwd(),
    })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "xur" then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

return {}
