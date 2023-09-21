{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hardware.nvidia;
in {
  options.hardware.nvidia.enable = mkEnableOption "nvidia";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [nvtop];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
