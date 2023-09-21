{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware.bluetooth;
in {
  config = mkIf cfg.enable {
    hardware.bluetooth.settings = {
      General = {
        Enable = "Headset,Source,Sink";
      };
    };
    #
    # systemd.user.services.mpris-proxy = {
    #   description = "mpris proxy";
    #   wantedBy = ["default.target"];
    #   after = ["network.target" "sound.target"];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    #   };
    # };
  };
}
