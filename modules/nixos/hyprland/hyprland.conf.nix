{
  config,
  hypr-keybinds,
  lib,
  pkgs,
  screenlock-cmd,
  ...
}:
with lib; let
  cfg = config.programs.hyprland;
in ''
  monitor=,preferred,auto,1

  exec-once = ${pkgs.swayidle}/bin/swayidle -w timeout 10 'if pgrep -x swaylock; then hyprctl dispatch dpms off; fi' resume 'hyprctl dispatch dpms on'
  exec-once = ${pkgs.swayidle}/bin/swayidle -w timeout 300 '${screenlock-cmd}' timeout 330 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

  ${optionalString (cfg.wallpapers != {}) "exec-once = ${pkgs.hyprpaper}/bin/hyprpaper"}

  source = ${toString config.programs.flavours.build.hyprland}
  source = ${toString hypr-keybinds}

  input {
      kb_layout = us
      kb_variant =
      kb_model =
      kb_options =
      kb_rules =

      follow_mouse = 1

      touchpad {
          natural_scroll = 0
          tap-to-click = 0
      }

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }

  general {
      border_size = 1
      gaps_in = 0
      gaps_out = 0
      layout = master
  }

  decoration {
      blur = no
      blur_new_optimizations = true
      blur_passes = 1
      blur_size = 3
      drop_shadow = false
      rounding = 0
      shadow_range = 4
      shadow_render_power = 3
  }

  animations {
      enabled = no
  }

  dwindle {
      pseudotile = false
      preserve_split = true
  }

  master {
      new_is_master = false
  }

  gestures {
      workspace_swipe = false
  }

  windowrulev2 = float,class:^(popup)$
  windowrulev2 = size 50% 50%,class:^(popup)$
  windowrulev2 = center,floating:1
  windowrulev2 = float,title:^(.*Huddle.*)$
''
