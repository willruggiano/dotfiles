{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.terminal.st;
  defaultFont = {
    packages = with pkgs; [
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    name = "JetBrainsMono Nerd Font Mono";
    size = 12;
  };
in
{
  options.modules.terminal.st = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      st
    ];

    fonts.fonts = with pkgs; [
    ];
  };
}
