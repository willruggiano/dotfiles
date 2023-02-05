{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.hyprland;
in ''
  monitor=,preferred,auto,1

  ${optionalString (cfg.wallpapers != {}) "exec-once = ${pkgs.hyprpaper}/bin/hyprpaper"}

  source = ~/.config/hypr/colors.conf
  source = ~/.config/hypr/keybinds.conf

  input {
      kb_layout = us
      kb_variant =
      kb_model =
      kb_options =
      kb_rules =

      follow_mouse = 1

      touchpad {
          natural_scroll = no
      }

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }

  general {
      gaps_in = 0
      gaps_out = 0
      border_size = 1

      layout = dwindle
  }

  decoration {
      rounding = 0
      blur = no
      blur_size = 3
      blur_passes = 1
      blur_new_optimizations = on

      drop_shadow = no
      shadow_range = 4
      shadow_render_power = 3
  }

  animations {
      enabled = no
  }

  dwindle {
      pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = yes # you probably want this
  }

  master {
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      new_is_master = true
  }

  gestures {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = off
  }
''