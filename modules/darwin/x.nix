{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.xquartz;
in {
  options.programs.xquartz.enable = mkEnableOption "XQuartz";

  config = mkIf cfg.enable {
    homebrew.casks = ["xquartz"];
  };
}
