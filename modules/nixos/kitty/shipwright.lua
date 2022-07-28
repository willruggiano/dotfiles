local kitty = require "shipwright.transform.contrib.kitty"

package.loaded["awesome"] = nil

run(require "awesome", function(colors)
  local theme = require "awesome.theme"
  local fg = theme.fg()
  local bg = theme.bg()
  return {
    fg = fg,
    bg = bg,
    cursor_fg = bg,
    cursor_bg = fg,
    selection_fg = colors.Normal.fg.hex,
    selection_bg = colors.Visual.bg.hex,
    black = colors.Black.fg.hex,
    red = colors.Red.fg.hex,
    green = colors.Green.fg.hex,
    yellow = "#FFFF00",
    blue = colors.Blue.fg.hex,
    magenta = "#FF00FF",
    cyan = "#00FFFF",
    white = colors.White.fg.hex,
    bright_black = colors.Black.fg.hex,
    bright_red = colors.Red.fg.hex,
    bright_green = colors.Green.fg.hex,
    bright_yellow = "#FFFF00",
    bright_blue = colors.Blue.fg.hex,
    bright_magenta = "#FF00FF",
    bright_cyan = "#00FFFF",
    bright_white = colors.White.fg.hex,
    --
    --   Optionally any of:
    --
    -- url = "#000000",
    -- border_active = "#000000",
    -- border_inactive = "#000000",
    -- border_bell = "#000000",
    -- titlebar = "#000000",
    -- tab_active_fg = "#000000",
    -- tab_active_bg = "#000000",
    -- tab_inactive_fg = "#000000",
    -- tab_inactive_bg = "#000000",
    -- tab_bg = "#000000",
    -- mark1_fg = "#000000",
    -- mark1_bg = "#000000",
    -- mark2_fg = "#000000",
    -- mark2_bg = "#000000",
    -- mark3_fg = "#000000",
    -- mark3_bg = "#000000",
  }
end, { kitty, "awesome" }, { overwrite, os.getenv "HOME" .. "/.config/kitty/theme.conf" })
