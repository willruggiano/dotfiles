{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.code;
in {
  options.programs.code = {
    enable = mkEnableOption "Enable vs-code";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["visual-studio-code"];
  };
}
