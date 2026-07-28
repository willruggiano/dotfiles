{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.trezord;
in {
  config = mkIf cfg.enable {
    # Not compatible with python 3.14!
    # environment.systemPackages = with pkgs; [trezorctl];
  };
}
