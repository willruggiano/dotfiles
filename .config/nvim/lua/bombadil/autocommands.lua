vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.fn.mkdir(vim.fn.expand "%:p:h", "p")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = vim.highlight.on_yank,
})
