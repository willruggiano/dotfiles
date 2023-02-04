{pkgs, ...}: ''
  $mod = ALT

  bind = $mod, RETURN, exec, ${pkgs.kitty}/bin/kitty
  bind = $mod SHIFT, RETURN, exec, ${pkgs.qutebrowser}/bin/qutebrowser
  bind = $mod SHIFT, C, killactive,
  bind = $mod, SPACE, togglefloating,
  bind = $mod, F, fullscreen, 0 # fullscreen
  bind = $mod, M, fullscreen, 1 # maximize (keeps gaps and bars)
  bind = $mod, P, pseudo, # dwindle
  bind = $mod, Q, exit,
  bind = $mod, R, exec, ${pkgs.wofi}/bin/wofi --show drun
  bind = $mod, S, togglesplit, # dwindle

  # Move focus with mod + arrow keys
  bind = $mod, H, movefocus, l
  bind = $mod, L, movefocus, r
  bind = $mod, K, movefocus, u
  bind = $mod, J, movefocus, d

  # Cycle workspaces with mod + j/k
  bind = $mod SHIFT, J, exec, hyprctl dispatch workspace +1
  bind = $mod SHIFT, K, exec, hyprctl dispatch workspace -1

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
''
