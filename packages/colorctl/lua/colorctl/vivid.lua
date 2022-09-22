local M = {}

local utils = require "colorctl.utils"
local vivid = require "colorctl.transform.vivid"
local overwrite = require "shipwright.transform.overwrite"

function M.run(opts)
  opts.dest = opts.dest or (os.getenv "HOME" .. "/.config/vivid/themes/colorctl.yml")

  ---@diagnostic disable-next-line: undefined-global
  require("shipwright").run(require "awesome", function(colors)
    local theme = require "awesome.theme"

    local fg = theme.fg()
    local bg = theme.bg()

    return {
      bg = utils.to_rrggbb(bg),
      fg = utils.to_rrggbb(fg),
      bad_fg = utils.to_rrggbb(colors.Error.fg.hex),
      bad_bg = utils.to_rrggbb(colors.Error.bg.hex),
      directory_fg = utils.to_rrggbb(colors.Directory.fg.hex),
      executable_fg = utils.to_rrggbb(colors.Palette4.fg.hex),
      executable_style = "bold",
      -- Filetypes
      cxx = utils.to_rrggbb(colors.DevIconCpp.fg.hex),
      lua = utils.to_rrggbb(colors.DevIconLua.fg.hex),
      nix = utils.to_rrggbb(colors.DevIconNix.fg.hex),
      shell = utils.to_rrggbb(colors.DevIconZsh.fg.hex),
      vim = utils.to_rrggbb(colors.DevIconVim.fg.hex),
      todo_fg = utils.to_rrggbb(colors.TodoBgTODO.fg.hex),
      todo_bg = utils.to_rrggbb(colors.TodoBgTODO.bg.hex),
      todo_style = colors.TodoBgTODO.gui,
    }
    ---@diagnostic disable-next-line: undefined-global
  end, { vivid, "awesome" }, { overwrite, opts.dest })
end

return M
