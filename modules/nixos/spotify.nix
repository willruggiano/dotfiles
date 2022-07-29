{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.spotify;
  spotifyd = pkgs.spotifyd.override {withPulseAudio = true;};
  spotifydConf = let
    backend =
      if config.hardware.pulseaudio.enable
      then "pulseaudio"
      else "alsa";
  in
    pkgs.writeText "spotifyd.conf" ''
      [global]
      username = "1211559862"
      password_cmd = "cat ${config.age.secrets.spotify.path}"
      backend = "${backend}"
    '';
in {
  options.programs.spotify = {
    enable = mkEnableOption "Enable spotify";
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.spotify-tui];

    systemd.user.services.spotifyd = {
      description = "spotifyd, a Spotify playing daemon";
      wantedBy = ["default.target"];
      environment.SHELL = "/bin/sh";
      serviceConfig = {
        ExecStart = "${spotifyd}/bin/spotifyd --no-daemon --cache-path ${config.user.home}/.cache/spotifyd --config-path ${spotifydConf}";
        Restart = "always";
        RestartSec = 12;
      };
    };
  };
}
