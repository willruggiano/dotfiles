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
      virtualisation.docker = {
        autoPrune.enable = true;
        enableOnBoot = true;
        extraPackages = [pkgs.docker-buildx];
      };
      user.extraGroups = ["docker"];
      environment.systemPackages = with pkgs'; [dtop lazydocker];
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
