if pcall(require, "cmp") then
  return
end

local inoremap = require("bombadil.lib.keymap").inoremap

vim.opt.completeopt = { "menuone", "noselect" }

-- Don't show the dumb matching stuff
vim.opt.shortmess:append "c"
vim.opt.pumheight = 20

require "coq_3p" {
  {
    src = "nvimlua",
    short_name = "nLUA",
    conf_only = false,
  },
  {
    src = "repl",
    sh = "zsh",
    -- shell = { p = "perl", n = "node", ... },
    max_lines = 99,
    deadline = 500,
  },
}

-- Overridden recommended keymaps to work with tabout.nvim
inoremap("<Esc>", function()
  return vim.fn.pumvisible() == 1 and "<C-e><Esc>" or "<Esc>"
end, { expr = true })
inoremap("<C-c>", function()
  return vim.fn.pumvisible() == 1 and "<C-e><C-c>" or "<C-c>"
end, { expr = true })
inoremap("<BS>", function()
  return vim.fn.pumvisible() == 1 and "<C-e><BS>" or "<BS>"
end, { expr = true })
inoremap("<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return (vim.fn.complete_info().selected == -1) and "<C-e><CR>" or "<C-y>"
  else
    return "<CR>"
  end
end, { expr = true })

-- Explicitly disabled in vim.g.coq_settings and mapped here instead to avoid the normal mode
-- mapping of the same key which conflicts with a custom mapping in keymaps.lua
inoremap("<c-h>", "<c-\\><c-n><cmd>lua COQ.Nav_mark()<cr>")
