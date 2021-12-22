{ config, lib, pkgs, ... }:

with lib;
let cfg = config.virtualisation;
in
{
  config = mkMerge [
    (mkIf cfg.docker.enable {
      user.extraGroups = [ "docker" ];
      user.packages = [ pkgs.lazydocker ];
    })
    (mkIf cfg.libvirtd.enable {
      user.extraGroups = [ "libvirtd" ];
      networking.firewall.checkReversePath = false;
    })
    (mkIf cfg.virtualbox.host.enable {
      virtualisation.virtualbox.host.enableExtensionPack = true;
      users.extraGroups.vboxusers.members = [ config.user.name ];
    })
  ];
}
