{
  config,
  pkgs,
  ...
}: let
  kitty = config.programs.kitty.package;
  window-selector = pkgs.writeShellApplication {
    name = "select-window";
    runtimeInputs = with pkgs; [fzf jq];
    text = ''
      hyprctl clients -j | jq --raw-output '.[] | (select(.pid != -1) | .pid | tostring) + ":" + .title' | fzf --delimiter : --preview "" --bind "enter:become(hyprctl dispatch focuswindow pid:{1})"
    '';
  };
  window-switcher = pkgs.writeShellApplication {
    name = "switch-window";
    runtimeInputs = [kitty];
    text = ''
      kitty --class popup sh -c '${window-selector}/bin/select-window'
    '';
  };
  move-focus = direction:
    pkgs.writeShellApplication {
      name = "move-focus";
      runtimeInputs = with pkgs; [jq];
      text = ''
        if hyprctl activewindow -j | jq -e 'select(.grouped != [])' >/dev/null
        then
          hyprctl dispatch changegroupactive
        else
          hyprctl dispatch movefocus ${direction}
        fi
      '';
    };
in ''
  $mod = ALT

  bind = $mod, RETURN, exec, ${kitty}/bin/kitty
  bind = $mod SHIFT, RETURN, exec, ${config.programs.brave.package}/bin/brave
  bind = $mod SHIFT, C, killactive,
  bind = $mod, SPACE, togglefloating,
  bind = $mod, F, layoutmsg, swapwithmaster master
  bind = $mod, M, fullscreen, 1 # maximize
  bind = $mod, P, pseudo, # dwindle
  bind = $mod, Q, exit,
  bind = $mod, R, exec, ${pkgs.wofi}/bin/wofi --show drun
  bind = $mod, S, togglesplit, # dwindle
  bind = $mod, W, exec, ${window-switcher}/bin/switch-window
  bind = $mod, O, focuscurrentorlast

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
