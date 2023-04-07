{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.brave;
in {
  options.programs.brave = {
    enable = mkEnableOption "brave browser";
    default = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.chromium.enable = true;
    }
    (mkIf cfg.default {
      environment.variables.BROWSER = "brave";
    })
  ]);
}
