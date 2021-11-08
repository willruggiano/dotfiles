{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.spotify;
  spotifyd = pkgs.spotifyd.override { withPulseAudio = true; };
  spotifydConf = pkgs.writeText "spotifyd.conf" ''
    [global]
    username = "1211559862"
    password_cmd = "cat /run/secrets/spotify"
    backend = "pulseaudio"
  '';
in
{
  options.programs.spotify = {
    enable = mkEnableOption "Enable spotify";
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.spotify-tui ];

    systemd.user.services.spotifyd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "sound.target" ];
      description = "spotifyd, a Spotify playing daemon";
      environment.SHELL = "/bin/sh";
      serviceConfig = {
        ExecStart = "${spotifyd}/bin/spotifyd --no-daemon --cache-path ${config.user.home}/.cache/spotifyd --config-path ${spotifydConf}";
        Restart = "always";
        RestartSec = 12;
      };
    };
  };
}
