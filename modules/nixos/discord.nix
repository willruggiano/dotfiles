{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.discord;
in {
  options.programs.discord = {
    enable = mkEnableOption "Enable discord";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
      dunst
    ];

    home.configFile = {
      "discord/settings.json".text = builtins.toJSON {
        SKIP_HOST_UPDATE = true;
      };
    };
  };
}
