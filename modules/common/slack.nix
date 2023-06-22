{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.slack;
in {
  options.programs.slack = {
    enable = mkEnableOption "Enable slack";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.slack
    ];
  };
}
