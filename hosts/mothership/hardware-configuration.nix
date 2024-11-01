{
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  kernelPackages = pkgs.linuxPackages_latest;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.system76
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "uas"
        "xhci_pci"
      ];
    };

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default: 8192
      "fs.inotify.max_queued_events" = 65536; # default: 16384
    };
    kernelModules = ["kvm-intel"];
    inherit kernelPackages;
    kernelParams = ["acpi_backlight=native"];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };
}
