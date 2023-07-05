{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.syncthing;
in {
  config = mkIf cfg.enable {
    services.syncthing = {
      user = config.user.name;
      systemService = false;
      dataDir = "${config.user.home}/.local/share/syncthing";
      configDir = "${config.user.home}/.config/syncthing";
      devices = {
        ecthelion = {id = "WANVEVH-JQEXPMR-GQVA3O7-NE6YZK6-ALTPZGJ-UGMRPAV-FKC7RIC-AOXOJQW";};
        mothership = {id = "PPDM2MU-LDXJPOV-ZPNC27H-XYM4KHC-N3L7Q4A-DSGTAHL-NNJK33S-ZIO2LAR";};
      };
      folders = {
        dev = {
          path = "${config.user.home}/dev";
          devices = ["ecthelion" "mothership"];
          ignorePerms = false;
        };
      };
    };

    home.file = {
      "dev/.stignore".text = ''
        !/tendrel/envrc
        *
      '';
    };
  };
}
