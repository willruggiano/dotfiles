{ config, lib, ... }:

with lib;
let cfg = config.security.pam.yubico;
in
{
  config = mkIf cfg.enable {
    security.pam.yubico = {
      debug = true;
      mode = "challenge-response";
    };
  };
}
