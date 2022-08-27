local M = {}

local utils = require "colorctl.utils"
local kitty = require "shipwright.transform.contrib.kitty"
local overwrite = require "shipwright.transform.overwrite"

function M.run(opts)
  opts.dest = opts.dest or (os.getenv "HOME" .. "/.config/kitty/theme.conf")

  ---@diagnostic disable-next-line: undefined-global
  require("shipwright").run(require "awesome", function(colors)
    local theme = require "awesome.theme"

    local fg = theme.fg()
    local bg = theme.bg()

    local offset = function(color, amount)
      if theme.is_dark() then
        return color.darken(amount)
      else
        return color.lighten(amount)
      end
    end

    local black = colors.Black.fg
    local red = colors.Palette4.fg
    local green = colors.Palette3.fg
    local yellow = colors.Palette1.fg
    local blue = colors.Palette5.fg
    local magenta = colors.Palette6.fg
    local cyan = colors.Palette5.fg
    local white = colors.White.fg

    return {
      fg = fg,
      bg = bg,
      cursor_fg = bg,
      cursor_bg = fg,
      selection_fg = colors.Normal.fg.hex,
      selection_bg = colors.Visual.bg.hex,
      black = black.hex,
      red = red.hex,
      green = green.hex,
      yellow = yellow.hex,
      blue = blue.hex,
      magenta = magenta.hex,
      cyan = cyan.hex,
      white = white.hex,
      bright_black = offset(black, 10).hex,
      bright_red = offset(red, 10).hex,
      bright_green = offset(green, 10).hex,
      bright_yellow = offset(yellow, 10).hex,
      bright_blue = offset(blue, 10).hex,
      bright_magenta = offset(magenta, 10).hex,
      bright_cyan = offset(cyan, 10).hex,
      bright_white = offset(white, 10).hex,
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
    ---@diagnostic disable-next-line: undefined-global
  end, { kitty, "awesome" }, { overwrite, opts.dest })

  if opts.reload then
    assert(opts.reload.command, "must have a reload.command for kitty")
    os.execute(utils.gsubenv(opts.reload.command))
  end
end

return M
