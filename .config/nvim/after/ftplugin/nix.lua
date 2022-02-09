vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

local ok, kommentary = pcall(require, "kommentary.config")
if not ok then
  return
end

kommentary.configure_language("nix", {
  single_line_comment_string = "#",
  prefer_single_line_comments = true,
})
