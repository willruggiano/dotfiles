{
  config,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot = {
      kernelModules = ["kvm-intel"];
      kernelPackages = pkgs.linuxPackages;
      # FIXME: don't have enough space in my boot partition :/
      # kernelPackages = pkgs.linuxPackages_latest;

      # FIXME: honestly not sure if these do anything useful
      # kernelParams = ["apm=power_off" "acpi=force" "reboot=acpi"];

      initrd = {
        availableKernelModules = [
          "vmd"
          "xhci_pci"
          "ahci"
          "nvme"
          "thunderbolt"
          "usbhid"
          "usb_storage"
          "sd_mod"
          "sr_mod"
        ];
      };

      kernel.sysctl = {
        "dev.tty.legacy_tiocsti" = 0;
        "fs.inotify.max_user_watches" = 1048576; # default: 8192
        "fs.inotify.max_queued_events" = 65536; # default: 16384
      };

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/ef563958-90f5-43ca-836c-49a70927012e";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/D49C-A0DE";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/d03258a4-fff4-4ac2-a861-7e9d1cd787a5";}
    ];

    powerManagement.cpuFreqGovernor = "powersave";

    hardware = {
      bluetooth.enable = true;
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
      enableRedistributableFirmware = true;
      i2c.enable = true;
      logitech.wireless.enable = true;
      nvidia.enable = true;
    };
  };
}
