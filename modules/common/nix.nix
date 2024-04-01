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

    dotfiles = {
      dir = mkOpt t.path "/etc/nixos";
      bin = mkOpt t.path "${config.dotfiles.dir}/bin";
      configDir = mkOpt t.path "${config.dotfiles.dir}/.config";
      modules = mkOpt t.path "${config.dotfiles.dir}/modules";
      themes = mkOpt t.path "${config.dotfiles.modulesDir}/themes";
    };

    home = {
      file = mkOpt t.attrs {};
      configFile = mkOpt t.attrs {};
      dataFile = mkOpt t.attrs {};
    };

    env = lib.mkOption {
      type = t.attrsOf (t.oneOf [t.str t.path (t.listOf (t.either t.str t.path))]);
      apply =
        lib.mapAttrs
        (n: v:
          if builtins.isList v
          then lib.concatMapStringsSep ":" builtins.toString v
          else (builtins.toString v));
      default = {};
      description = "";
    };

    term = mkOpt t.str "kitty";
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

    env.PATH = ["${config.dotfiles.bin}" "$XDG_BIN_HOME" "$PATH"];

    environment.extraInit =
      lib.concatStringsSep "\n"
      (lib.mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
