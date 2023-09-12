# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
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
      nvidia = {
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        powerManagement.enable = false;
      };
      opengl = {
        enable = true;
        driSupport = true;
      };
    };

    services.xserver = {
      videoDrivers = ["nvidia"];
    };
  };
}
