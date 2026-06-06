------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor {
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
}

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
local latitude = os.getenv "LATITUDE"
local longitude = os.getenv "LONGITUDE"
hl.on("hyprland.start", function()
  hl.exec_cmd "hypridle"
  hl.exec_cmd("wlsunset -l " .. latitude .. " -L " .. longitude)
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

local base00 = os.getenv "BASE_00"
local base01 = os.getenv "BASE_01"
local base02 = os.getenv "BASE_02"
local base05 = os.getenv "BASE_05"
local base09 = os.getenv "BASE_09"
local base0B = os.getenv "BASE_0B"
local base0D = os.getenv "BASE_0D"

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config {
  animations = {
    enabled = false,
  },

  decoration = {
    blur = {
      enabled = false,
    },

    rounding = 0,

    shadow = {
      enabled = false,
    },
  },

  dwindle = {
    force_split = 1,
  },

  general = {
    border_size = 1,

    col = {
      active_border = base0D,
      inactive_border = base01,
    },

    gaps_in = 0,
    gaps_out = 0,

    layout = "scrolling",
  },

  group = {
    col = {
      border_active = base0B,
      border_inactive = base01,
      border_locked_active = base09,
      border_locked_inactive = base01,
    },

    groupbar = {
      col = {
        active = base02,
        inactive = base01,
      },
      text_color = base05,
    },
  },

  input = {
    touchpad = {
      tap_to_click = true,
    },
  },

  misc = {
    background_color = base00,
  },
}

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule {
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
}

hl.window_rule {
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
}

hl.window_rule {
  name = "float-xdg-desktop-portals",
  match = {
    class = "xdg-desktop-portal-gtk",
  },

  float = true,
}

hl.window_rule {
  name = "float-brave-popups",
  match = {
    initial_title = "Untitled - Brave",
  },

  float = true,
}

hl.window_rule {
  name = "float-modals",
  match = { modal = true },

  border_size = 0,
  float = true,
  no_shadow = true,
}

local special = "special:magic"
hl.workspace_rule {
  workspace = special,
  gaps_in = 5,
  gaps_out = 20,
  layout = "dwindle",
}

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mod = "SUPER"

local lock_session = "loginctl lock-session"
hl.bind(mod .. " + End", hl.dsp.exec_cmd(lock_session))

local toggle_dark_mode = "darkman toggle"
hl.bind(mod .. " + F12", hl.dsp.exec_cmd(toggle_dark_mode))

local printscreen = 'grim -g "$(slurp)" "$HOME/Downloads/screenshot-$(date -Is).png"'
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(printscreen))

local launcher = "hyprlauncher"
hl.bind(mod .. " + R", hl.dsp.exec_cmd(launcher))

local terminal = "kitty"
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))

local browser = os.getenv "BROWSER"
hl.bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(browser))

local window_switcher =
  [[hyprctl clients -j | jq -r '.[] | (select(.pid != -1) | .pid | tostring) + " " + (select(.title != "") | .title)' | wofi --show dmenu | { read -r pid title; hyprctl dispatch focuswindow "pid:$pid"; }]]
hl.bind(mod .. " + W", hl.dsp.exec_cmd(window_switcher))

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special "magic")
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move { workspace = special })

hl.bind(mod .. " + C", hl.dsp.window.center())
hl.bind(mod .. " + SHIFT + C", hl.dsp.window.close())
hl.bind(mod .. " + SPACE", hl.dsp.window.float { action = "toggle" })

local function layout_bind(bind_table)
  return function()
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

    if not workspace then
      return
    end

    local layout = workspace.tiled_layout

    if bind_table[layout] then
      hl.dispatch(bind_table[layout])
    end
  end
end

hl.bind(
  mod .. " + K",
  layout_bind {
    scrolling = hl.dsp.layout "focus l",
    dwindle = hl.dsp.window.cycle_next { next = false },
    monocle = hl.dsp.layout "cycleprev",
    master = hl.dsp.layout "cycleprev",
  }
)

hl.bind(
  mod .. " + J",
  layout_bind {
    scrolling = hl.dsp.layout "focus r",
    dwindle = hl.dsp.window.cycle_next { next = true },
    monocle = hl.dsp.layout "cyclenext",
    master = hl.dsp.layout "cyclenext",
  }
)
hl.bind(mod .. " + O", hl.dsp.focus { last = true })

for i = 1, 10 do
  local key = i % 10 -- 10 -> 0
  hl.bind(mod .. " + " .. key, hl.dsp.focus { workspace = i })
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move { workspace = i })
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus { workspace = "e+1" })
hl.bind(mod .. " + mouse_up", hl.dsp.focus { workspace = "e-1" })
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
  { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%+", { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%-", { locked = true, repeating = true })
