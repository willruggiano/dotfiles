local bufferline = require "bufferline"

bufferline.setup {
  options = {
    view = "multiwindow",
    numbers = "ordinal",
    indicator_icon = " * ",
    modified_icon = "[+]",
    diagnostics = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
}

local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("]b", function()
  bufferline.cycle(1)
end)
nnoremap("[b", function()
  bufferline.cycle(-1)
end)
