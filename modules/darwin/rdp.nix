{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.rdp;
in {
  options.programs.rdp.enable = mkEnableOption "Microsoft Remote Desktop";

  config = mkIf cfg.enable {
    homebrew.casks = ["microsoft-remote-desktop"];
  };
}
