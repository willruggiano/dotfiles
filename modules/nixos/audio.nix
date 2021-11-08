{ config, lib, pkgs, ... }:

with lib;
{
  config = mkIf config.hardware.pulseaudio.enable (mkMerge [
    {
      sound.enable = true;
      user.extraGroups = [ "audio" ];
      hardware.pulseaudio.package = pkgs.pulseaudioFull;
    }
    (mkIf config.hardware.bluetooth.enable {
      hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
      hardware.bluetooth.settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };

      systemd.user.services.mpris-proxy = {
        description = "mpris proxy";
        wantedBy = [ "default.target" ];
        after = [ "network.target" "sound.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        };
      };
    })
  ]);
}
