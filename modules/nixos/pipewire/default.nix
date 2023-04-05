{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.pipewire;
in {
  config = mkIf cfg.enable {
    sound.enable = false;

    security.rtkit.enable = true;

    services.pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };

    environment.etc = {
      "wireplumber/bluetooth.lua.d/50-bluez-config.lua".source = ./bluetooth.lua;
    };
  };
}
