local M = {}

local utils = require "colorctl.utils"
local qutebrowser = require "colorctl.transform.qutebrowser"
local overwrite = require "shipwright.transform.overwrite"

function M.run(opts)
  opts.dest = opts.dest or (os.getenv "HOME" .. "/.config/qutebrowser/colors.yml")

  ---@diagnostic disable-next-line: undefined-global
  require("shipwright").run(require "awesome", function(colors)
    local theme = require "awesome.theme"

    local fg = theme.fg()
    local bg = theme.bg()

    return {
      statusbar_normal_bg = fg,
      statusbar_normal_fg = bg,
    }
    ---@diagnostic disable-next-line: undefined-global
  end, { qutebrowser, "awesome" }, { overwrite, opts.dest })

  -- if opts.reload then
  --   assert(opts["reload-command"], "must have a reload.command for qutebrowser")
  --   os.execute(utils.gsubenv(opts["reload-command"]))
  -- end
end

return M
