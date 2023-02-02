{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.flavours;
in {
  options.programs.flavours = {
    enable = mkEnableOption "Enable flavours";
    colorscheme = mkOption {
      type = types.str;
      default = "tomorrow-night-eighties";
    };
    shell = mkOption {
      type = types.str;
      default = "bash -c '{}'";
    };
    items = mkOption {
      default = {};
      type = types.attrsOf (
        types.submodule (name: {
          options = {
            file = mkOption {
              type = types.oneOf [types.str types.path];
            };
            rewrite = mkOption {
              type = types.bool;
              default = true;
            };
            template = mkOption {
              type = types.str;
            };
          };
        })
      );
    };
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.flavours];

    home.configFile = {
      flavours = {
        source = ../../.config/flavours;
        recursive = true;
      };

      "flavours/config.toml".text = let
        format = pkgs.formats.toml {};
        items = mapAttrsToList (name: attrs:
          concatStringsSep "\n" [
            "[[items]]"
            (builtins.readFile (format.generate "${name}-flavours-config.toml" attrs))
          ])
        cfg.items;
      in
        concatStringsSep "\n\n" ([''shell = "${cfg.shell}"''] ++ items);
    };

    system.userActivationScripts.flavours = ''
      ${pkgs.flavours}/bin/flavours apply ${cfg.colorscheme}
    '';
  };
}
