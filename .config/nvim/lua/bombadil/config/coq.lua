if pcall(require, "cmp") then
  error "[setup] both nvim-cmp and coq.nvim are installed"
  return
end

require "bombadil.config.coq-setup"

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
    max_lines = 99,
    deadline = 500,
  },
}

local function pumvisible()
  return vim.fn.pumvisible() == 1
end

local function pumselected()
  return vim.fn.complete_info().selected ~= -1
end

local inoremap = require("bombadil.lib.keymap").inoremap

inoremap("<Esc>", function()
  return pumvisible() and "<C-e><Esc>" or "<Esc>"
end, { expr = true })

inoremap("<BS>", function()
  return pumvisible() and "<C-e><BS>" or "<BS>"
end, { expr = true })

inoremap("<C-y>", function()
  if pumvisible() then
    return pumselected() and "<C-y>" or "<C-n><C-y>"
  else
    return "<C-y>"
  end
end, { expr = true })

inoremap("<CR>", function()
  if pumvisible() then
    if pumselected() then
      return "<C-y>"
    else
      return "<C-e><CR>"
    end
  else
    return "<CR>"
  end
end, { expr = true })

local neogen = require "neogen"

inoremap("<C-h>", function()
  if neogen.jumpable() then
    -- NOTE: We close the completion menu first. This is why this has to go by expr.
    return [[<C-e><cmd>lua require("neogen").jump_next()<cr>]]
  else
    return "<cmd>lua COQ.Nav_mark()<cr>"
  end
end, { desc = "Jump to mark", expr = true })
