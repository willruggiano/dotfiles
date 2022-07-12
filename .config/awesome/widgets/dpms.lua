local awful = require "awful"
local wibox = require "wibox"

local dpms = true

local function format_dpms(toggle)
  if (dpms and not toggle) or (not dpms and toggle) then
    return "+dpms"
  else
    return "-dpms"
  end
end

local widget = wibox.widget.textbox()

awful.spawn.easy_async_with_shell("xset q", function(stdout, _, _, exit_code)
  if exit_code == 0 then
    local text = string.match(stdout, "DPMS is (%a+)")
    if text and text == "Disabled" then
      dpms = false
    end
  end
  widget:set_text(format_dpms())
end)

widget:buttons(awful.util.table.join(awful.button({}, 1, function()
  local command = { "xset " .. format_dpms(true) }
  if dpms then
    -- Then we're turning it off
    table.insert(command, "xset s noblank")
    table.insert(command, "xset s off")
  else
    -- Then we're turning it on
    table.insert(command, "xset s blank")
    table.insert(command, "xset s on")
  end
  awful.spawn.easy_async_with_shell(table.concat(command, ";"), function(_, _, _, exit_code)
    if exit_code == 0 then
      dpms = not dpms
      widget:set_text(format_dpms())
    end
  end)
end)))

return widget
