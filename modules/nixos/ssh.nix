{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.ssh;
  inherit (config) sshPublicKey;
in {
  options.services.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
    };

    user.openssh.authorizedKeys.keys = [sshPublicKey];
  };
}
