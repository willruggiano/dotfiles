{
  config,
  lib,
  packages,
  modulesPath,
  ...
}: {
  boot.loader.grub.enable = true;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];
}
