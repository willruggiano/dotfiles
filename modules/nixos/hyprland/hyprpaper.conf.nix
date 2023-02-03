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
        preload = ${attrs.wallpaper}
        wallpaper = ${monitor},${attrs.wallpaper}
      ''
    )
    wallpapers;
in
  concatStringsSep "\n" configs
