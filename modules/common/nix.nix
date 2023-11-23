{
  options,
  config,
  lib,
  ...
}:
with lib; {
  options = with types; {
    user = mkOpt attrs {};

    dotfiles = {
      dir = mkOpt path "/etc/nixos";
      bin = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/.config";
      modules = mkOpt path "${config.dotfiles.dir}/modules";
      themes = mkOpt path "${config.dotfiles.modulesDir}/themes";
    };

    home = {
      file = mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [str path (listOf (either str path))]);
      apply =
        mapAttrs
        (n: v:
          if isList v
          then concatMapStringsSep ":" toString v
          else (toString v));
      default = {};
      description = "";
    };

    term = mkOpt str "kitty";
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
          file = mkAliasDefinitions options.home.file;
          stateVersion = "21.05";
        };
        xdg = {
          enable = true;
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users."${config.user.name}" = mkAliasDefinitions options.user;

    env.PATH = ["${config.dotfiles.bin}" "$XDG_BIN_HOME" "$PATH"];

    environment.extraInit =
      concatStringsSep "\n"
      (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
