{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.mopidy;
in
{
  config = mkIf cfg.enable {
    user.packages = [ pkgs.mopidy ];

    services.mopidy = {
      extensionPackages = [
        pkgs.mopidy-spotify
      ];
    };
  };
}
