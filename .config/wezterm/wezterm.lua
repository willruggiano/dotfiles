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
  if t.hour < 8 or t.hour > 17 then
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
  left = "0.5cell",
  right = "0.5cell",
  top = "0.5cell",
  bottom = 0,
}

return config
