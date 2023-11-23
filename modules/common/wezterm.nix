{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.wezterm;
in {
  options.programs.wezterm = {
    enable = mkEnableOption "Enable wezterm";
    package = mkPackageOption pkgs "wezterm" {};
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    home.configFile = {
      wezterm = {
        source = ../../.config/wezterm;
        recursive = true;
      };
    };

    term = "wezterm";
  };
}
