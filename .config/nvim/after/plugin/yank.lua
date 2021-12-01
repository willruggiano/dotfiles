-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.register {
  Y = { "y$", "Yank to end-of-line" },
}
