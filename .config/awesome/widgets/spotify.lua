local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"

local widget = wibox.widget.textbox()

gears.timer {
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = function()
    awful.spawn.easy_async_with_shell([[spt playback --format "%s %t - %a"]], function(stdout, _, _, exit_code)
      if exit_code == 0 then
        widget:set_text(stdout)
      else
        widget:set_text ""
      end
    end)
  end,
}

return widget
