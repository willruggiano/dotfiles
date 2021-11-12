{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    fonts.enableFontDir = true;
    fonts.fonts = with pkgs; [
      font-awesome
    ];
  };
}
