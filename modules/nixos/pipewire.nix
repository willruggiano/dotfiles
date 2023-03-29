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

      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [{"device.name" = "~bluez_card.*";}];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = ["hfp_hf" "hsp_hs" "a2dp_sink"];
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
              # SBC-XQ is not expected to work on all headset + adapter combinations.
              "bluez5.sbc-xq-support" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            {"node.name" = "~bluez_input.*";}
            # Matches all outputs
            {"node.name" = "~bluez_output.*";}
          ];
        }
      ];
    };
  };
}
