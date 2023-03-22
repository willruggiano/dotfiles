{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.flavours;
in {
  options.programs.flavours = with types; {
    enable = mkEnableOption "Enable flavours";
    colorscheme = mkOption {
      type = str;
      default = "tomorrow-night-eighties";
    };
    items = mkOption {
      default = {};
      type = attrsOf (
        submodule (name: {
          options = {
            template = mkOption {
              type = oneOf [str path];
            };
          };
        })
      );
    };

    build = mkOption {
      type = attrsOf package;
      internal = true;
    };
  };

  config = {
    programs.flavours.build =
      mapAttrs (
        name: attrs:
          pkgs.runCommand "${name}-flavours" {buildInputs = [pkgs.flavours];} ''
            flavours build "${pkgs.base16-schemes}/${cfg.colorscheme}.yaml" "${attrs.template}" > $out
          ''
      )
      cfg.items;
  };
}
