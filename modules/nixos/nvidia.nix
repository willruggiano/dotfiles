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

    virtualisation.docker.enableNvidia = true;
  };
}
