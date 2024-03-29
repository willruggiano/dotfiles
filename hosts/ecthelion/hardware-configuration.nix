{
  config,
  pkgs,
  modulesPath,
  ...
}: let
  kernelPackages = pkgs.linuxPackages_latest;
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot = {
      extraModulePackages = with kernelPackages; [acpi_call];

      initrd = {
        availableKernelModules = [
          "ahci"
          "nvme"
          "sd_mod"
          "sr_mod"
          "thunderbolt"
          "usb_storage"
          "usbhid"
          "vmd"
          "xhci_pci"
        ];
      };

      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 1048576; # default: 8192
        "fs.inotify.max_queued_events" = 65536; # default: 16384
      };
      kernelModules = ["acpi_call" "kvm-intel"];
      inherit kernelPackages;

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
      device = "/dev/disk/by-uuid/D49C-A0DE";
      fsType = "vfat";
    };

    swapDevices = [
      {device = "/dev/disk/by-label/swap";}
    ];

    powerManagement.cpuFreqGovernor = "powersave";

    hardware = {
      bluetooth.enable = true;
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
      enableRedistributableFirmware = true;
      nvidia.enable = true;
    };
  };
}
