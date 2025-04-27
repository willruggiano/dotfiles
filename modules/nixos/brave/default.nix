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
    package = mkPackageOption pkgs "brave" {};
    default = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [cfg.package];
      programs.chromium.enable = true;
    }
    (mkIf cfg.default {
      environment.sessionVariables = {
        BROWSER = "${cfg.package}/bin/brave";
        DEFAULT_BROWSER = "${cfg.package}/bin/brave";
      };
    })
  ]);
}
