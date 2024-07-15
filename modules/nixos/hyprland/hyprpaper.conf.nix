{
  config,
  lib,
  ...
}:
with lib; let
  inherit (config.programs.hyprland) wallpapers;
  configs =
    mapAttrsToList (
      monitor: attrs: ''
        preload = ${attrs.source}
        wallpaper = ${monitor},${attrs.source}
      ''
    )
    wallpapers;
in
  concatStringsSep "\n" (["# vim: ft=hyprlang"] ++ configs)
