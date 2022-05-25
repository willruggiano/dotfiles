{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.blender;
in {
  options.programs.blender = {
    enable = mkEnableOption "blender";
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.blender];
  };
}
