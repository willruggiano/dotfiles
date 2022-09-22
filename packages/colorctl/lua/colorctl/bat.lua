local M = {}

local utils = require "colorctl.utils"
local bat = require "colorctl.transform.bat"
local overwrite = require "shipwright.transform.overwrite"

function M.run(opts)
  opts.dest = opts.dest or (os.getenv "HOME" .. "/.config/bat/themes/awesome.tmTheme")

  ---@diagnostic disable-next-line: undefined-global
  require("shipwright").run(require "awesome", function(colors)
    local theme = require "awesome.theme"

    local fg = theme.fg()
    local bg = theme.bg()

    return {
      bg = bg,
      caret = colors.Error.fg.hex,
      fg = fg,
      invisibles = colors.Error.fg.hex,
      highlight = colors.Highlighter.fg.hex,
      selection = colors.Visual.bg.hex,
      comment = colors.Comment.fg.hex,
      string = colors.String.fg.hex,
      constant = colors.Constant.fg.hex,
      keyword = colors.Keyword.fg.hex,
      type = colors.Error.fg.hex,
      ["function"] = colors.Error.fg.hex,
      identifier = colors.Identifier.fg.hex,
      invalid_bg = colors.Error.bg.hex,
      invalid_fg = colors.Error.fg.hex,
    }
    ---@diagnostic disable-next-line: undefined-global
  end, { bat, "awesome" }, { overwrite, opts.dest })

  if opts.reload then
    assert(opts["reload-command"], "must have a reload.command for bat")
    os.execute(utils.gsubenv(opts["reload-command"]))
  end
end

return M
