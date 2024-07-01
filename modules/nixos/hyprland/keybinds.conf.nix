{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) term;

  # I wonder if there's a way we can write a "kitten" for this?
  reload-kitty-theme = pkgs.writeShellApplication {
    name = "reload-kitty-theme";
    runtimeInputs = with pkgs; [config.programs.${term}.package coreutils procps];
    text = ''
      scheme() {
        local h
        h=$(date +%k)
        (( h <= 8 || h >= 17 )) && echo "tomorrow-night-eighties" || echo "tomorrow"
      }

      link() {
        ln -sf "${../../common/kitty}/base16-$(scheme).conf" "$HOME/.config/kitty/current-theme.conf"
      }

      reload() {
        kill -SIGUSR1 $(pgrep kitty)
      }

      link && reload
    '';
  };

  window-switcher = pkgs.writeShellApplication {
    name = "switch-window";
    runtimeInputs = with pkgs; [wofi];
    text = ''
      # shellcheck disable=SC2034
      hyprctl clients -j | jq -r '.[] | (select(.pid != -1) | .pid | tostring) + " " + (select(.title != "") | .title)' | wofi --show dmenu | { read -r pid title; hyprctl dispatch focuswindow "pid:$pid"; }
    '';
  };
in ''
  $mod = ALT

  bind = $mod, RETURN, exec, ${lib.getExe config.programs.${term}.package}
  bind = $mod SHIFT, RETURN, exec, ${lib.getExe config.programs.brave.package}
  bind = $mod SHIFT, C, killactive
  bind = $mod, SPACE, togglefloating
  bind = $mod, C, centerwindow
  bind = $mod, F, layoutmsg, swapwithmaster master
  bind = $mod, M, fullscreen, 1 # maximize
  bind = $mod, O, focuscurrentorlast
  bind = $mod, Q, exit
  bind = $mod, R, exec, ${pkgs.wofi}/bin/wofi --show drun
  bind = $mod, S, togglespecialworkspace
  bind = $mod SHIFT, S, movetoworkspace, special
  bind = $mod, W, exec, ${window-switcher}/bin/switch-window
  bind = , F12, exec, ${reload-kitty-theme}/bin/reload-kitty-theme
  bind = , End, exec, ${pkgs.systemd}/bin/loginctl lock-session
  bind = , Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$HOME/Downloads/screenshot-$(date -Is).png"

  # Move/resize windows with mouse
  bindm = $mod, mouse:272, movewindow
  bindm = $mod, mouse:273, resizewindow

  # Move focus
  bind = $mod, J, layoutmsg, cyclenext
  bind = $mod, K, layoutmsg, cycleprev

  # Cycle workspaces with mod + j/k
  bind = $mod SHIFT, J, workspace, +1
  bind = $mod SHIFT, K, workspace, -1

  # Switch workspaces with mod + [0-9]
  bind = $mod, 1, workspace, 1
  bind = $mod, 2, workspace, 2
  bind = $mod, 3, workspace, 3
  bind = $mod, 4, workspace, 4
  bind = $mod, 5, workspace, 5
  bind = $mod, 6, workspace, 6
  bind = $mod, 7, workspace, 7
  bind = $mod, 8, workspace, 8
  bind = $mod, 9, workspace, 9
  bind = $mod, 0, workspace, 10

  # Move active window to a workspace with mod + SHIFT + [0-9]
  bind = $mod SHIFT, 1, movetoworkspace, 1
  bind = $mod SHIFT, 2, movetoworkspace, 2
  bind = $mod SHIFT, 3, movetoworkspace, 3
  bind = $mod SHIFT, 4, movetoworkspace, 4
  bind = $mod SHIFT, 5, movetoworkspace, 5
  bind = $mod SHIFT, 6, movetoworkspace, 6
  bind = $mod SHIFT, 7, movetoworkspace, 7
  bind = $mod SHIFT, 8, movetoworkspace, 8
  bind = $mod SHIFT, 9, movetoworkspace, 9
  bind = $mod SHIFT, 0, movetoworkspace, 10

  bind = , XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
  bind = , XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  bind = , XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bind = , XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5
  bind = , XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 5
''
