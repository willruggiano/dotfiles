{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.obs-studio;
in {
  options.programs.obs-studio = {
    enable = mkEnableOption "Enable obs-studio";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = let
      obs = pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [wlrobs];
      };
    in [obs];
  };
}
