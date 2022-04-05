{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.tigervnc;
in {
  options.programs.tigervnc = {
    enable = mkEnableOption "Enable TigerVNC";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["tigervnc-viewer"];
  };
}
