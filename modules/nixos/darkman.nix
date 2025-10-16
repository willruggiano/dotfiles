{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.darkman;
  yamlFormat = pkgs.formats.yaml {};
in {
  options.services.darkman = {
    enable = lib.mkEnableOption ''
      darkman, a tool that automatically switches dark-mode on and off based on
      the time of the day'';

    package = lib.mkPackageOption pkgs "darkman" {};

    settings = lib.mkOption {
      type = lib.types.submodule {freeformType = yamlFormat.type;};
      default = {
        lat = 37.45;
        lng = -122.28;
        # usegeoclue = true;
      };
      description = ''
        Settings for the {command}`darkman` command. See
        <https://darkman.whynothugo.nl/#CONFIGURATION> for details.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    home.configFile = {
      "darkman/config.yaml" = lib.mkIf (cfg.settings != {}) {
        source = yamlFormat.generate "darkman-config.yaml" cfg.settings;
      };
    };

    xdg.portal = {
      config.common = {
        "org.freedesktop.impl.portal.Settings" = ["darkman"];
      };
    };
  };
}
