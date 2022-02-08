local M = {}

M.shiftwidth = function(i)
  vim.bo.shiftwidth = i
  vim.bo.softtabstop = i
  vim.bo.tabstop = i
end

return M
