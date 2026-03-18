{
  config,
  lib,
  options,
  ...
}: let
  t = lib.types;
  mkOpt = type: default: lib.mkOption {inherit type default;};
in {
  options = {
    user = mkOpt t.attrs {};

    home = {
      file = mkOpt t.attrs {};
      configFile = mkOpt t.attrs {};
      dataFile = mkOpt t.attrs {};
    };
  };

  config = {
    user = {
      description = "The primary user account";
      uid = 1000;
    };

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

    users.users."${config.user.name}" = lib.mkAliasDefinitions options.user;
  };
}
