{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.kbfs;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [keybase-gui];
  };
}
