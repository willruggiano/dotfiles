local M = {}

local lazygit = require "colorctl.transform.lazygit"
local overwrite = require "shipwright.transform.overwrite"

function M.run(opts)
  opts.dest = opts.dest or (os.getenv "HOME" .. "/.config/lazygit/theme.yml")

  ---@diagnostic disable-next-line: undefined-global
  require("shipwright").run(require "awesome", function(_)
    local theme = require "awesome.theme"

    return {
      light_theme = (theme.is_dark() == false),
    }
    ---@diagnostic disable-next-line: undefined-global
  end, { lazygit, "awesome" }, { overwrite, opts.dest })
end

return M
