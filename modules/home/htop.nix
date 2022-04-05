{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.htop;
in {
  config = mkIf cfg.enable {
    programs.htop.settings = {
      show_program_path = true;
    };
  };
}
