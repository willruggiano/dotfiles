{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.obs-studio;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = let
      obs = pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [wlrobs];
      };
    in [obs];
  };
}
