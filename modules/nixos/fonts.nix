{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    fonts.fonts = with pkgs; [
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      nonicons
    ];
  };
}
