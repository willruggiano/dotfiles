local keymap = vim.keymap

local noremap = { noremap = true, silent = true }

local M = {}

M.noremap = function(modes, lhs, rhs, opts)
  keymap.set(modes, lhs, rhs, vim.tbl_extend("force", noremap, opts or {}))
end

--- Apply a set of mappings.
---@param modes table the modes to apply mappings for
---@param mappings table a table of the form: { <lhs> = { <rhs>, [<opts>] }
---@param opts table options to apply to all mappings
M.noremaps = function(modes, mappings, opts)
  opts = opts or {}
  for lhs, mapping in pairs(mappings) do
    M.noremap(modes, lhs, mapping[1], vim.tbl_extend("force", mapping[2] or {}, opts))
  end
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
