{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.kbfs;
in {
  config = mkIf cfg.enable {
    # insecure?
    # environment.systemPackages = with pkgs; [keybase-gui];
  };
}
