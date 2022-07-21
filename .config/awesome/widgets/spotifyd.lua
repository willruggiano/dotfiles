local beautiful = require "beautiful"
local dbus = require "dbus_proxy"
local gears = require "gears"

local wibox = require "wibox"

local spotify = {}

function spotify:new(opts)
  return setmetatable({}, { __index = self }):init(opts)
end

function spotify:init(opts)
  self.font = opts.font or beautiful.font
  self.icons = opts.icons or {
    play = "",
    pause = "",
    stop = "",
  }
  self.autohide = opts.autohide == nil and false or opts.autohide

  self.widget = wibox.widget {
    {
      id = "icon",
      widget = wibox.widget.textbox,
    },
    {
      id = "current_song",
      widget = wibox.widget.textbox,
      font = self.font,
    },
    layout = wibox.layout.fixed.horizontal,
    set_status = function(self, icon)
      self.icon.markup = string.format([[<span>%s </span>]], icon)
    end,
    set_text = function(self, text)
      self.current_song.markup = text
    end,
  }

  self.dbus = dbus.monitored.new {
    bus = dbus.Bus.SESSION,
    name = "org.mpris.MediaPlayer2.spotifyd",
    path = "/org/mpris/MediaPlayer2",
    interface = "org.mpris.MediaPlayer2.Player",
  }

  self:watch(opts.refresh_rate)

  return self
end

function spotify:update_widget_icon(output)
  output = string.gsub(output, "\n", "")
  self.widget:set_status(output == "Playing" and self.icons.play or self.icons.pause)
end

local function escape_xml(str)
  str = string.gsub(str, "&", "&amp;")
  str = string.gsub(str, "<", "&lt;")
  str = string.gsub(str, ">", "&gt;")
  str = string.gsub(str, "'", "&apos;")
  str = string.gsub(str, '"', "&quot;")
  return str
end

function spotify:update_widget_text(output)
  self.widget:set_text(escape_xml(output))
  self.widget:set_visible(true)
end

function spotify:hide_widget()
  self.widget:set_text "n/a"
  self.widget:set_status(self.icons.stop)
  self.widget:set_visible(not self.autohide)
end

function spotify:info()
  if not self.dbus.is_connected then
    return
  end

  local metadata = self.dbus:Get(self.dbus.interface, "Metadata")
  local status = self.dbus:Get(self.dbus.interface, "PlaybackStatus")

  local artists = metadata["xesam:artist"]
  if type(artists) == "table" then
    artists = table.concat(artists, ", ")
  end

  return {
    album = metadata["xesam:album"],
    title = metadata["xesam:title"],
    artists = artists,
    status = status,
  }
end

function spotify:watch(refresh_rate)
  gears.timer {
    timeout = refresh_rate,
    call_now = true,
    autostart = true,
    callback = function()
      local info = self:info()
      if info then
        if info.artists and info.title then
          self:update_widget_icon(info.status)
          self:update_widget_text(string.format("%s - %s", info.title, info.artists))
        end
      else
        self:hide_widget()
      end
    end,
  }
end

return setmetatable(spotify, { __call = spotify.new })
