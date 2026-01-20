{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hardware.nvidia;
in {
  options.hardware.nvidia.enable = lib.mkEnableOption "nvidia";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.cudaSupport = true;
    nix.settings = {
      substituters = ["https://cache.nixos-cuda.org"];
      trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
    };

    environment.systemPackages = with pkgs; [nvtopPackages.full];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
      };
      nvidia-container-toolkit.enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
