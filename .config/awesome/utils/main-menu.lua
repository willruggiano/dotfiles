local awful = require "awful"
local hotkeys_popup = require ""

local browser = "qutebrowser"
local terminal = "kitty"
local editor = os.getenv "EDITOR" or "nano"

local function exec(command)
  return terminal .. " zsh -c " .. command
end

return function()
  local awesome_menu = {
    {
      "hotkeys",
      function()
        hotkeys_popup.show_help(nil, awful.screen.focused())
      end,
    },
    { "manual", exec "man awesome" },
    { "edit config", exec(editor .. " " .. "/etc/nixos/.config/awesome/rc.lua") },
    { "restart", awesome.restart },
    {
      "quit",
      function()
        awesome.quit()
      end,
    },
  }

  local function pass_clip()
    awful.spawn(exec "pass-clipcat", {
      floating = true,
      placement = awful.placement.centered,
      height = 250,
    })
  end

  local main_menu = awful.menu {
    items = {
      { "awesome", awesome_menu },
      { "terminal", terminal },
      { "pass", pass_clip },
      { "firefox-private", "firefox-private" },
      { "qutebrowser", browser },
      { "qutebrowser-private", "qutebrowser-private" },
      {
        "bluetooth",
        function()
          awful.spawn(exec "fzf-bluetooth", {
            floating = true,
            placement = awful.placement.centered,
            height = 300,
          })
        end,
      },
      {
        "wifi",
        function()
          awful.spawn(exec "fzf-wifi", {
            floating = true,
            placement = awful.placement.centered,
            height = 300,
          })
        end,
      },
      {
        "xplr",
        function()
          awful.spawn(exec "xplr", {
            floating = true,
            placement = awful.placement.centered,
          })
        end,
      },
    },
  }

  return main_menu
end
