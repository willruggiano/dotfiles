{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.spotify;
  backend =
    if config.services.pulseaudio.enable
    then "pulseaudio"
    else "alsa";
  device_name = "spotifyd@${config.networking.hostName}";
in {
  options.programs.spotify = {
    enable = mkEnableOption "Enable spotify";
  };

  config = mkIf cfg.enable {
    services.spotifyd = {
      enable = true;
      settings.global = {
        inherit backend device_name;
        username = "1211559862";
        device_type = "computer";
      };
    };
  };
}
