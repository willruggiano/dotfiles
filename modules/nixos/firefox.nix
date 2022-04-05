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
    enable = mkEnableOption "Enable firefox";
    default = mkEnableOption "Make firefox the default browser";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        firefox-extended
      ];
    })
    (mkIf cfg.default {
      environment.variables.BROWSER = "firefox";
    })
  ];
}
