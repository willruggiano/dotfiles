local inoremap = vim.keymap.inoremap

if vim.g.started_by_firenvim then
  vim.bo.laststatus = 0
  vim.bo.nonumber = true
  vim.bo.norelativenumber = true
  vim.bo.noruler = true
  vim.bo.noshowcmd = true

  inoremap { "<tab>", "<c-n>" }
  inoremap { "<s-tab>", "<c-p>" }
end
