local template = [[
gui:
  theme:
    lightTheme: $light_theme
]]

local helpers = require "shipwright.transform.helpers"
local utils = require "colorctl.utils"

local check_keys = {
  "light_theme",
}

local function transform(colors)
  utils.check_keys("lazygit", colors, check_keys)
  return helpers.split_newlines(helpers.apply_template(template, colors))
end

return transform
