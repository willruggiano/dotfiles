{ config, lib, ... }:

with lib;

let
  cfg = config.services.ssh;
  sshPublicKey = config.sshPublicKey;
in
{
  options.services.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
    };

    user.openssh.authorizedKeys.keys = [ sshPublicKey ];
  };
}
