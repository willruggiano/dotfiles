{
  config,
  lib,
  options,
  ...
}: let
  t = lib.types;
  attrsOpt = lib.mkOption {
    type = t.attrs;
    default = {};
  };
in {
  options = {
    user = attrsOpt;
    home = {
      file = attrsOpt;
      configFile = attrsOpt;
      dataFile = attrsOpt;
    };
  };

  config = {
    home-manager = {
      useUserPackages = true;

      users."${config.user.name}" = {
        home = {
          file = lib.mkAliasDefinitions options.home.file;
          stateVersion = "21.05";
        };
        xdg = {
          enable = true;
          configFile = lib.mkAliasDefinitions options.home.configFile;
          dataFile = lib.mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    # FIXME: This needs to be fixed soon!
    users.users."${config.user.name}" = lib.mkAliasDefinitions options.user;
  };
}
