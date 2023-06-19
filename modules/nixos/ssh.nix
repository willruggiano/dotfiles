{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.ssh;
in {
  options.services.ssh = {
    enable = mkEnableOption "Enable ssh";
  };

  config = mkIf cfg.enable {
    age.secrets."${config.user.name}@${config.networking.hostName}".path = "${config.user.home}/.ssh/id_ed25519";

    home.file.".ssh/id_ed25519.pub".source = ../../hosts/${config.networking.hostName}/id_ed25519.pub;

    programs.mosh.enable = true;
    services.openssh = {
      enable = true;
      settings = {
        kbdInteractiveAuthentication = false;
        passwordAuthentication = false;
      };
    };

    user.openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADhTkgTJq0zQcHRhHLJL4u/FzaiHPle2Ly8mlQfVqQv willruggiano@moria"
      ];
      keyFiles = [
        ../../hosts/ecthelion/id_ed25519.pub
        ../../hosts/mothership/id_ed25519.pub
      ];
    };
  };
}
