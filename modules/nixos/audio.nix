{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.hardware.pulseaudio.enable (mkMerge [
    {
      sound.enable = true;
      user.extraGroups = ["audio"];
      hardware.pulseaudio.package = pkgs.pulseaudioFull;
    }
    (mkIf config.hardware.bluetooth.enable {
      hardware.bluetooth.settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };

      hardware.pulseaudio.extraConfig = ''
        load-module module-switch-on-connect
      '';

      systemd.user.services.mpris-proxy = {
        description = "mpris proxy";
        wantedBy = ["default.target"];
        after = ["network.target" "sound.target"];
        serviceConfig = {
          ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        };
      };
    })
  ]);
}
