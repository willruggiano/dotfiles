{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.expressvpn;
in {
  config = mkIf cfg.enable {
    services.openvpn.servers = {
      expressvpn-dallas = {
        config = "config ${config.age.secrets.expressvpn-dallas.path}";
        autoStart = false;
      };
    };

    systemd.services.expressvpn-reconnect = {
      description = "Restart OpenVPN after suspend";
      wantedBy = ["sleep.target"];
      serviceConfig = {
        ExecStart = "${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn";
      };
    };
  };
}
