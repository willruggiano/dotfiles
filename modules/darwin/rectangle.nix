{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.rectangle;
in {
  options.programs.rectangle = {
    enable = mkEnableOption "Enable rectangle";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["rectangle"];
  };
}
