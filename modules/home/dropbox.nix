{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.dropbox;
in
{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.dropbox-cli ];
  };
}
