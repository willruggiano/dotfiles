vim.opt.termguicolors = true

local bufferline = require "bufferline"

local hidden_buffers = {
  quickfix = true,
}

local function setup()
  bufferline.setup {
    options = {
      view = "multiwindow",
      numbers = "ordinal",
      indicator_icon = " * ",
      modified_icon = "[+]",
      diagnostics = false,
      custom_filter = function(bufnr, bufnrs)
        if hidden_buffers[vim.bo[bufnr].buftype] == true then
          return false
        end

        return true
      end,
      show_buffer_close_icons = false,
      show_close_icon = false,
    },
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("]b", function()
    bufferline.cycle(1)
  end, { desc = "Next buffer" })

  nnoremap("[b", function()
    bufferline.cycle(-1)
  end, { desc = "Previous buffer" })
end

return { setup = setup }
