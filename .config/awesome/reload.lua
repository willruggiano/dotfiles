return function()
  -- package.loaded["awesome"] = nil
  -- package.loaded["beautiful"] = nil
  package.loaded["theme"] = nil

  require("beautiful").init(require "theme")

  ---@diagnostic disable-next-line: undefined-global
  awesome.emit_signal "wallpaper_changed"

  require("awful").screen.connect_for_each_screen(require "utils.screen")
end
