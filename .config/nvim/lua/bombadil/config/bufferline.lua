vim.opt.termguicolors = true

local bufferline = require "bufferline"

local hidden_buffers = {
  man = true,
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
        local bo = vim.bo[bufnr]
        local bt = hidden_buffers[bo.buftype] == true
        local ft = hidden_buffers[bo.filetype] == true
        if bt or ft then
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
