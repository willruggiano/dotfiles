if vim.fn.executable "lazygit" ~= 1 then
  return
end

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new {
  cmd = "lazygit",
  direction = "float",
  border = "single",
  hidden = true,
}

local nnoremap = require("bombadil.lib.keymap").nnoremap
nnoremap("<space>g", function()
  ---@diagnostic disable-next-line: missing-parameter
  lazygit:toggle()
end, { desc = "Lazygit" })
