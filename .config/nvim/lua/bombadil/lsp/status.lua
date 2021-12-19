local icons = require "nvim-nonicons"
local nvim_status = require "lsp-status"

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

local sign_to_status = {
  Error = "indicator_errors",
  Hint = "indicator_hint",
  Info = "indicator_info",
  Warn = "indicator_warnings",
}

status.activate = function()
  local config = {
    indicator_ok = icons.get "check",
    select_symbol = status.select_symbol,
    spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
    status_symbol = "",
  }
  require("bombadil.lsp.signs").map(function(signs, key)
    config[sign_to_status[key]] = signs[key]
  end)

  nvim_status.config(config)
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
