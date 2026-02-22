{
  config,
  lib,
  pkgs,
  pkgs',
  ...
}:
with lib; let
  cfg = config.virtualisation;
in {
  config = mkMerge [
    (mkIf cfg.docker.enable {
      environment.systemPackages = with pkgs'; [dtop lazydocker];
      networking.firewall.trustedInterfaces = ["docker0"];
      user.extraGroups = ["docker"];
      virtualisation.docker = {
        autoPrune.enable = true;
        enableOnBoot = true;
        extraPackages = [pkgs.docker-buildx];
      };
    })
    (mkIf cfg.podman.enable {
      environment.systemPackages = [pkgs.podman-compose];
      user.extraGroups = ["podman"];
      virtualisation = {
        containers.enable = true;
        podman = {
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    })
    (mkIf cfg.libvirtd.enable {
      user.extraGroups = ["libvirtd"];
      networking.firewall.checkReversePath = false;
    })
    (mkIf cfg.virtualbox.host.enable {
      virtualisation.virtualbox.host.enableExtensionPack = true;
      users.extraGroups.vboxusers.members = [config.user.name];
    })
  ];
}
