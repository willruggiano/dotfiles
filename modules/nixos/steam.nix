{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.steam;
in
{
  config = mkIf cfg.enable {
    user.packages = with pkgs; with steamPackages; [
      steamcmd
      steam-tui
    ];
  };
}
