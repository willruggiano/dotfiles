local template = [[
colors.statusbar.normal.bg: '$statusbar_normal_bg'
colors.statusbar.normal.fg: '$statusbar_normal_fg'
]]

local helpers = require "shipwright.transform.helpers"
local utils = require "colorctl.utils"

local check_keys = {
  "statusbar_normal_fg",
  "statusbar_normal_bg",
}

local function transform(colors)
  utils.check_keys("qutebrowser", colors, check_keys)
  return helpers.split_newlines(helpers.apply_template(template, colors))
end

return transform
