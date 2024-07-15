{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.bat;
  inherit (config.programs.flavours) colorscheme;
in {
  options.programs.bat = {
    enable = mkEnableOption "bat";
    package = mkPackageOption pkgs "bat" {};
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    # home.configFile = {
    #   "bat/config".text = ''
    #     --map-syntax='*.tpp:C++'
    #     --theme='${colorscheme}'
    #   '';
    #
    #   "bat/themes/${colorscheme}.tmTheme".source = config.lib.stylix.colors {
    #     template
    #   };
    # };
  };
}
