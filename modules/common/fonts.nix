{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    fonts.fontDir.enable = true;
    fonts.fonts = with pkgs; [
      font-awesome
    ];
  };
}
