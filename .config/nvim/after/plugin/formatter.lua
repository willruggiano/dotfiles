local ok, _ = pcall(require, "formatter")
if not ok then
  return
end

local nnoremap = vim.keymap.nnoremap

nnoremap { "<leader>f", "<cmd>Format<cr>", silent = true }
