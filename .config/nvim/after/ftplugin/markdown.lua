vim.wo.conceallevel = 3

local ok, tu = pcall(require, "treesitter-unit")
if ok then
  tu.disable_highlighting()
end
