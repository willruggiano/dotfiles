local awful = require "awful"
local gears = require "gears"
local naughty = require "naughty"
local wibox = require "wibox"

local textbox = wibox.widget.textbox()

-- awful.popup {
--   widget = awful.widget.tasklist {
--     screen = screen[1],
--     filter = awful.widget.tasklist.filter.allscreen,
--     buttons = tasklist_buttons,
--     style = {
--       shape = gears.shape.rounded_rect,
--     },
--     layout = {
--       spacing = 5,
--       forced_num_rows = 2,
--       layout = wibox.layout.grid.horizontal,
--     },
--     widget_template = {
--       {
--         {
--           id = "clienticon",
--           widget = awful.widget.clienticon,
--         },
--         margins = 4,
--         widget = wibox.container.margin,
--       },
--       id = "background_role",
--       forced_width = 48,
--       forced_height = 48,
--       widget = wibox.container.background,
--       create_callback = function(self, c, index, objects) --luacheck: no unused
--         self:get_children_by_id("clienticon")[1].client = c
--       end,
--     },
--   },
--   border_color = "#777777",
--   border_width = 2,
--   ontop = true,
--   placement = awful.placement.centered,
--   shape = gears.shape.rounded_rect,
-- }
-- awful.popup {
--   widget = awful.widget.prompt {
--     prompt = "<b>Run: </b>",
--   },
--   border_color = "#777777",
--   border_width = 2,
--   ontop = true,
--   placement = awful.placement.centered,
--   shape = gears.shape.rectangle,
-- }

local popup = awful.popup {
  widget = wibox.widget.textbox(),
  ontop = true,
  placement = awful.placement.bottom + awful.placement.maximize_horizontally,
  shape = gears.shape.rectangle,
}

awful.prompt.run {
  prompt = "<b>Echo: </b>",
  bg_cursor = "#ff0000",
  textbox = popup.widget,
  exe_callback = function(input)
    if not input or #input == 0 then
      return
    end
    naughty.notify { text = "This input was: " .. input }
  end,
}

-- awful.menu.clients()
