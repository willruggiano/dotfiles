{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.pipewire;
in {
  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    home.configFile = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
  };
}
