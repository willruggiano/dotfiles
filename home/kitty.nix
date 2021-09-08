{ config, lib, pkgs, ... }:

let
  font = {
    package = pkgs.fira-code;
    name = "FiraCode";
    size = 12;
  };
in
{
  programs.kitty = {
    enable = true;
    settings = {
      disable_ligatures = "never";
      enable_audio_bell = "no";
      sync_to_monitor = "no";
    };
    extraConfig = ''
      symbol_map U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26a1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D JetBrains Mono Nerd Font
      symbol_map U+F101-U+F208 nonicons
    '';
    font = font;
  };
}
