{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.keeping-you-awake;
in {
  options.programs.keeping-you-awake = {
    enable = mkEnableOption "Enable KeepingYouAwake";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["keepingyouawake"];
  };
}
