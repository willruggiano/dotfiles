{
  config,
  hypr-keybinds,
  lib,
  pkgs,
  ...
}:
with lib;
with config.lib.stylix.colors; let
  inherit (import ./lib.nix) rgb;
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

  exec-once = ${lib.getExe pkgs.wlsunset} -l ${toString config.location.latitude} -L ${toString config.location.longitude}

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
    shadow {
      enabled = false
    }
    rounding = 0

    blur {
      enabled = false
    }
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

  windowrule = float,class:^()$
  windowrule = float,class:^(brave)$
  windowrule = float,class:^(xdg-desktop-portal-gtk)$
  windowrule = float,initialTitle:^(about:blank)
  windowrule = float,title:^MainPicker$
''
