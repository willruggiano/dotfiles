local beautiful = require "beautiful"
local wibox = require "wibox"

return wibox.widget {
  {
    max_value = 1,
    value = 0.5,
    forced_height = 100,
    forced_widget = 20,
    paddings = 1,
    border_width = 1,
    border_color = beautiful.border_color,
    widget = wibox.widget.progressbar,
  },
  {
    text = "50%",
    widget = wibox.widget.textbox,
  },
  layout = wibox.layout.stack,
}
