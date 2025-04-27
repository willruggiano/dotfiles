{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.bat;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    home.configFile = {
      "bat/config".text = ''
        --theme='base16-stylix'
      '';

      "bat/themes/base16-stylix.tmTheme".source = config.lib.stylix.colors {
        template = ./base16-bat.mustache;
        extension = ".tmTheme";
      };
    };
  };
}
