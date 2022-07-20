local awful = require "awful"
local wibox = require "wibox"

local layout = "dvp" -- N.B. programmer's dvorak

local function get_layout()
  if layout == "dvp" then
    return "us"
  else
    return "dvp"
  end
end

local widget = wibox.widget.textbox()

-- TODO: Detect which layout is in use
-- awful.spawn.easy_async_with_shell("xset q", function(stdout, _, _, exit_code)
--   if exit_code == 0 then
--     local text = string.match(stdout, "DPMS is (%a+)")
--     if text and text == "Disabled" then
--       dpms = false
--     end
--   end
-- end)

widget:set_text("[" .. layout .. "]")

widget:buttons(awful.util.table.join(awful.button({}, 1, function()
  local next_layout = get_layout()
  awful.spawn.easy_async_with_shell("setxkbmap " .. next_layout, function(_, _, _, exit_code)
    if exit_code == 0 then
      layout = next_layout
      widget:set_text("[" .. layout .. "]")
    end
  end)
end)))

return widget
