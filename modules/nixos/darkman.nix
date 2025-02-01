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

    # this seems to be the key?
    xdg.portal.extraPortals = [pkgs.darkman];

    # Uh... idk how the unit file is getting in there?
    # systemd.user.services.darkman = {
    #   description = "Framework for dark-mode and light-mode transitions.";
    #   documentation = ["man:darkman(1)"];
    #   partOf = ["graphical-session.target"];
    #   bindsTo = ["graphical-session.target"];
    #   # restartTriggers =
    #   #   lib.mkIf (cfg.settings != {})
    #   #   ["${config.home.configFile."darkman/config.yaml".source}"];
    #   serviceConfig = {
    #     Type = "dbus";
    #     BusName = "nl.whynothugo.darkman";
    #     ExecStart = "${lib.getExe cfg.package} run";
    #     Restart = "on-failure";
    #     TimeoutStopSec = 15;
    #     Slice = "background.slice";
    #   };
    #   wantedBy = lib.mkDefault ["graphical-session.target"];
    # };
  };
}
