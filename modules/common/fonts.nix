{ config, lib, pkgs, ... }:

with lib;

{
  config = {
    # NOTE: nix-darwin does not have the fontDir option. So sticking with the legacy one for now.
    fonts.enableFontDir = true;
    fonts.fonts = with pkgs; [
      font-awesome
    ];
  };
}
