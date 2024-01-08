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
    # TODO: Dark and light themes
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
    colors = mkOption {
      type = attrsOf str;
      internal = true;
    };
  };

  config = {
    programs.flavours = {
      build =
        mapAttrs (
          name: attrs:
            pkgs.runCommandLocal "${name}-flavours" {buildInputs = [pkgs.flavours];} ''
              flavours build "${pkgs.base16-schemes}/share/themes/${cfg.colorscheme}.yaml" "${attrs.template}" > $out
            ''
        )
        cfg.items;

      colors = {};
    };
  };
}
