{ config, options, lib, home-manager, ... }:

with lib;
with lib.my;
{
  options = with types; {
    user = mkOpt attrs { };

    dotfiles = {
      dir = mkOpt path "/etc/nixos";
      bin = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/.config";
      modules = mkOpt path "${config.dotfiles.dir}/modules";
      themes = mkOpt path "${config.dotfiles.modulesDir}/themes";
    };

    home = {
      file = mkOpt' attrs { } "Files to place directly in $HOME";
      configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v:
          if isList v
          then concatMapStringsSep ":" (x: toString x) v
          else (toString v));
      default = { };
      description = "";
    };
  };

  config = {
    user =
      let
        user = builtins.getEnv "USER";
        name = if elem user [ "" "root" ] then "bombadil" else user;
      in
      {
        inherit name;
        description = "The primary user account";
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
        uid = 1000;
      };

    home-manager = {
      useUserPackages = true;

      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix = let users = [ "root" config.user.name ]; in
      {
        trustedUsers = users;
        allowedUsers = users;
      };

    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit =
      concatStringsSep "\n"
        (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
