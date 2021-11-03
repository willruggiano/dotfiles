{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.discord;
in
{
  options.programs.discord = {
    enable = mkEnableOption "Enable discord";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      discord
      dunst
    ];

    home.configFile = {
      "discord/settings.json".text = ''
        {
          "SKIP_HOST_UPDATE": true
        }
      '';
    };
  };
}
