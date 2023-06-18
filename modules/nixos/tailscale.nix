{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.tailscale;
in {
  config = mkIf cfg.enable {
    networking.nameservers = ["100.100.100.100" "8.8.8.8" "1.1.1.1"];
    networking.search = ["tailc7072.ts.net"];
  };
}
