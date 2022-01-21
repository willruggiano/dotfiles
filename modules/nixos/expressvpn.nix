{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.expressvpn;
in
{
  options.services.expressvpn = {
    enable = mkEnableOption "ExpressVPN";
  };

  config = mkIf cfg.enable {
    services.openvpn.servers = {
      expressvpn-dallas = {
        config = "config ${config.age.secrets.expressvpn-dallas.path}";
      };
    };
  };
}
