{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.mopidy;
in
{
  config = mkIf cfg.enable {
    services.mopidy = {
      extraConfigFiles = [
        "~/.config/mopidy/mopidy.conf"
      ];
      extensionPackages = [
        pkgs.mopidy-iris
        pkgs.mopidy-local
        pkgs.mopidy-spotify
      ];
    };
  };
}
