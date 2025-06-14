{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.virtualisation;
in {
  config = mkMerge [
    (mkIf cfg.docker.enable {
      virtualisation.docker = {
        enableOnBoot = true;
        autoPrune.enable = true;
      };
      user.extraGroups = ["docker"];
      environment.systemPackages = [pkgs.docker-buildx pkgs.lazydocker];
      networking.firewall.trustedInterfaces = ["docker0"];
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
