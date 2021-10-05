{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.terminal.font;
in
{
  options.modules.terminal.font = { };

  config = {
    fonts.fonts = with pkgs; [
      jetbrains-mono
      my.nonicons
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}
