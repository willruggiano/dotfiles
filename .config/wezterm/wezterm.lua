local wezterm = require "wezterm"
local config = wezterm.config_builder()

local scheme = {
  light = "Tomorrow",
  dark = "Tomorrow Night Eighties",
}

config.color_scheme = (function()
  local override = os.getenv "BG"
  if override then
    return scheme[override]
  end
  local t = os.date "*t"
  -- Use light theme between 8am and 8pm, dark theme otherwise
  if t.hour < 8 or t.hour > 20 then
    return scheme.dark
  else
    return scheme.light
  end
end)()

-- Disables ligatures in most fonts.
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font = wezterm.font_with_fallback {
  { family = "JetBrains Mono", weight = "Light" },
  "nonicons",
}

config.enable_scroll_bar = false
config.enable_tab_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
