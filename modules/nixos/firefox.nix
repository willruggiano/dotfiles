{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.firefox;
in {
  options.programs.firefox = {
    default = mkEnableOption "Make firefox the default browser";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [pkgs.firefox];
    })
    (mkIf cfg.default {
      environment.variables.BROWSER = "firefox";
    })
  ];
}
