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
      };
      folders = {
        dev = {
          path = "${config.user.home}/dev";
          devices = ["ecthelion"];
        };
      };
    };
  };
}
