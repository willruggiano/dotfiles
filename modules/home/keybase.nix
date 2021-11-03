{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.kbfs;
in
{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.keybase-gui ];
  };
}
