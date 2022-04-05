{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.bartender;
in {
  options.programs.bartender = {
    enable = mkEnableOption "Enable bartender";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["bartender"];
  };
}
