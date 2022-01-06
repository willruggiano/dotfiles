local keymap = vim.keymap

local noremap = { noremap = true, silent = true }

local M = {}

M.noremap = function(modes, lhs, rhs, opts)
  keymap.set(modes, lhs, rhs, vim.tbl_extend("force", noremap, opts or {}))
end

M.inoremap = function(lhs, rhs, opts)
  M.noremap("i", lhs, rhs, opts)
end
M.nnoremap = function(lhs, rhs, opts)
  M.noremap("n", lhs, rhs, opts)
end
M.tnoremap = function(lhs, rhs, opts)
  M.noremap("t", lhs, rhs, opts)
end
M.vnoremap = function(lhs, rhs, opts)
  M.noremap("v", lhs, rhs, opts)
end

return M
