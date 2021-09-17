local nvim_status = require "lsp-status"
local icons = require "nvim-nonicons"

local status = {}

status.select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ["start"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[1]),
      },
      ["end"] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[2]),
      },
    }

    return require("lsp-status.util").in_range(cursor_pos, value_range)
  end
end

status.activate = function()
  nvim_status.config {
    select_symbol = status.select_symbol,

    indicator_errors = icons.get "circle-slash",
    indicator_warnings = icons.get "alert",
    indicator_info = icons.get "info",
    indicator_hint = icons.get "light-bulb",
    indicator_ok = icons.get "check",
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  }

  nvim_status.register_progress()
end

status.on_attach = function(client)
  nvim_status.on_attach(client)

  vim.cmd [[
    augroup MyLspStatusGroup
      autocmd CursorHold,BufEnter <buffer> lua require('lsp-status').update_current_function()
    augroup END
  ]]
end

return status
