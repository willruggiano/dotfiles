local gears = require "gears"
local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"

local dpi = require("beautiful").xresources.apply_dpi

local volume_ctrl = require "widgets.volume"
local net_widgets = require "widgets.network"

local set_wallpaper = require("utils.wallpaper").set_wallpaper

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list { theme = { width = 250 } }
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

local function replace(what, s, widget)
  if s[what] ~= nil then
    s[what] = nil
  end

  return widget
end

return function(s)
  -- Create a command prompt for each screen
  s.prompt_box = awful.widget.prompt()

  s.command_prompt = replace(
    "command_prompt",
    s,
    awful.popup {
      widget = wibox.widget.textbox(),
      ontop = true,
      placement = awful.placement.bottom + awful.placement.maximize_horizontally,
      shape = gears.shape.rectangle,
    }
  )

  -- Create a taglist widget
  s.tag_list = replace(
    "tag_list",
    s,
    awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
      buttons = taglist_buttons,
    }
  )

  -- Create a tasklist widget
  s.task_list = replace(
    "task_list",
    s,
    awful.widget.tasklist {
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons,
      layout = {
        fill_space = false,
        layout = wibox.layout.fixed.horizontal,
      },
      widget_template = {
        {
          {
            {
              id = "icon_role",
              widget = wibox.widget.imagebox,
            },
            margins = dpi(2),
            widget = wibox.container.margin,
          },
          left = dpi(10),
          right = dpi(10),
          widget = wibox.container.margin,
        },
        id = "background_role",
        widget = wibox.container.background,
      },
    }
  )

  -- Create the wibox
  if s.wibox ~= nil then
    s.wibox:remove()
  end
  s.wibox = awful.wibar { position = "top", screen = s }

  -- Add widgets to the wibox
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(s.tag_list)
  left_layout:add(s.prompt_box)

  local middle_layout = s.task_list

  local right_layout = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = 10,
  }
  if s.index == 1 then
    right_layout:add(wibox.widget.systray())
  end

  local spotify = require "widgets.spotifyd" { autohide = true, refresh_rate = 5 }

  right_layout:add(spotify.widget)
  right_layout:add(net_widgets.indicator { timeout = 5 })
  -- right_layout:add(net_widgets.wireless { timeout = 5 })
  -- right_layout:add(require "widgets.brightness")
  right_layout:add(require "widgets.cpu")
  right_layout:add(volume_ctrl.widget)
  right_layout:add(require "widgets.battery")
  right_layout:add(require "widgets.dpms")
  right_layout:add(wibox.widget.textclock())
  right_layout:add(require "widgets.keyboard-layout")

  s.wibox:setup {
    layout = wibox.layout.align.horizontal,
    left_layout,
    middle_layout,
    right_layout,
  }
end
