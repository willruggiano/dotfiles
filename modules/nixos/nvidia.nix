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
      nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
      };
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
