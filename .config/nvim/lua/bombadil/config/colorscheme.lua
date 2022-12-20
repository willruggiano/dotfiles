assert(vim.opt.termguicolors, "termguicolors must be set")

if pcall(require, "awesome") then
  vim.cmd "colorscheme awesome"
elseif pcall(require, "github-theme") then
  require("github-theme").setup()
end
