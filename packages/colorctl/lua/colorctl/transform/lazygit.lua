local template = [[
gui:
  theme:
    lightTheme: $light_theme
]]

local helpers = require "shipwright.transform.helpers"
local check_keys = {
  "light_theme",
}

local function transform(colors)
  for _, key in ipairs(check_keys) do
    assert(colors[key], "lazygit colors table missing required key: " .. key)
  end
  return helpers.split_newlines(helpers.apply_template(template, colors))
end

return transform
