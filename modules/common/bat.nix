{
  config,
  lib,
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

    programs.flavours.items.bat = {
      template = "${pkgs.base16-templates}/templates/textmate/templates/default.mustache";
    };

    home.configFile = {
      "bat/config".text = ''
        --map-syntax='*.tpp:C++'
        --theme='${colorscheme}'
      '';

      # "bat/themes/${colorscheme}.tmTheme".source = config.programs.flavours.build.bat;
    };
  };
}
