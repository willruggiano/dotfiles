{
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
        "uas"
      ];
    };

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 1048576; # default: 8192
      "fs.inotify.max_queued_events" = 65536; # default: 16384
    };
    kernelModules = ["kvm-intel"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["acpi_backlight=native"];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0286fdee-d493-47ef-93b3-8c16cb3bfc13";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CF44-4C64";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  services.xserver.videoDrivers = ["modesetting"];
  swapDevices = [{device = "/dev/disk/by-uuid/32c7c0d9-72b7-409c-af0e-aac996048097";}];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    system76.enableAll = true;
    bluetooth.enable = true;
    graphics.enable = true;
  };
}
