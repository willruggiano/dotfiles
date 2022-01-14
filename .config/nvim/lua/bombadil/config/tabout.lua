local inoremap = require("bombadil.lib.keymap").inoremap

-- NOTE: Disabling completion and manually setting it up below
require("tabout").setup { completion = false }

inoremap("<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or [[<cmd>lua require"tabout".tabout()<cr>]]
end, { expr = true })
inoremap("<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or [[<cmd>lua require"tabout".taboutBack()<cr>]]
end, { expr = true })
