local execute = vim.api.nvim_command

require("marks").setup {}

local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<leader>mb", function()
  execute "MarksListBuf"
end, { desc = "Buffer marks" })

nnoremap("<leader>ml", function()
  execute "MarksListAll"
end, { desc = "Marks" })
