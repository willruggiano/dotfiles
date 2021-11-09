{ config, lib, pkgs, ... }:

with lib;
let cfg = config.virtualisation.docker;
in
{
  config = mkIf cfg.enable {
    user.extraGroups = [ "docker" ];
  };
}
