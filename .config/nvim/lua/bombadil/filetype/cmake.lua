return function(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
    require("bombadil.lib.augend").register_buffer "cmake"
  end)
end