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
    environment.systemPackages = with pkgs; [trezorctl];
  };
}
