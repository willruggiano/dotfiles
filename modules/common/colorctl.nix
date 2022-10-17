{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.colorctl;
in {
  options.programs.colorctl = {
    enable = mkEnableOption "Enable colorctl";
    settings = mkOption {
      description = "Attribute set of application specific configuration";
      default = {};
      type = types.attrsOf (
        types.submodule (name: {
          options = {
            enable = mkEnableOption "Enable colorctl for ${name}";
            reload-command = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Command to run to reload ${name}";
            };
          };
        })
      );
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [colorctl];
  };
}
