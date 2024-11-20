{
  config,
  hypr-keybinds,
  lib,
  pkgs,
  ...
}:
with lib;
with config.lib.stylix.colors; let
  inherit (import ./lib.nix) rgb rgba;
  cfg = config.programs.hyprland;
in ''
  # vim: ft=hyprlang

  env = XDG_SESSION_TYPE,wayland

  ${optionalString config.hardware.nvidia.enable "env = LIBVA_DRIVER_NAME,nvidia"}
  ${optionalString config.hardware.nvidia.enable "env = GBM_BACKEND,nvidia-drm"}
  ${optionalString config.hardware.nvidia.enable "env = __GLX_VENDOR_LIBRARY_NAME,nvidia"}

  monitor = ,preferred,auto,1

  ${optionalString cfg.extensions.hypridle.enable "exec-once = ${lib.getExe pkgs.hypridle}"}
  ${optionalString (cfg.wallpapers != {}) "exec-once = ${lib.getExe pkgs.hyprpaper}"}

  source = ${toString hypr-keybinds}

  animations {
    enabled = no
  }

  env = HYPRCURSOR_THEME,${cfg.cursor.theme}
  env = HYPRCURSOR_SIZE,${toString cfg.cursor.size}
  cursor {
    no_hardware_cursors = true
  }

  decoration {
    drop_shadow = false
    rounding = 0
    shadow_range = 4
    shadow_render_power = 3

    blur {
      enabled = no
    }

    col.shadow = ${rgba base00 "99"}
  }

  dwindle {
    pseudotile = false
    preserve_split = true
  }

  general {
    border_size = 1
    gaps_in = 0
    gaps_out = 0
    layout = master

    col.active_border = ${rgb base0A}
    col.inactive_border = ${rgb base03}
  }

  gestures {
    workspace_swipe = false
  }

  group {
    col.border_active = ${rgb base06}
    col.border_inactive = ${rgb base0D}
    col.border_locked_active = ${rgb base06}
  }

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

  master {
    new_status = master
  }

  misc {
    background_color = ${rgb base00}
  }

  windowrulev2 = float,initialTitle:^(about:blank)
  windowrulev2 = idleinhibit,initialTitle:^(about:blank)
  windowrulev2 = float,class:^(brave)$

  windowrulev2 = float,title:^MainPicker$
''
