{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.emanote;
in
{
  config = mkIf cfg.enable {
    services.emanote.notes = [ "${config.home.homeDirectory}/notes" ];

    home.packages = with pkgs; [ zk ];

    xdg.configFile.zk = {
      source = ../../.config/zk;
      recursive = true;
    };
  };
}
