{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.docker;
in {
  options.programs.docker = {
    enable = mkEnableOption "Enable docker";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["docker"];
    user.packages = [pkgs.docker];
  };
}
