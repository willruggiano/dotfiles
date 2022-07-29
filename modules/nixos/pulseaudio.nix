{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware.pulseaudio;
in {
  config = mkIf cfg.enable (mkMerge [
    {
      hardware.pulseaudio.package = pkgs.pulseaudioFull;
    }
    (mkIf config.hardware.bluetooth.enable {
      hardware.pulseaudio.extraConfig = ''
        load-module module-switch-on-connect
      '';
    })
  ]);
}
