{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.programs.nvidia-omniverse = {
    enable = mkEnableOption "Nvidia omniverse";
  };

  options.programs.nvtop = {
    enable = mkEnableOption "nvtop";
  };

  config = mkMerge [
    (mkIf config.programs.nvidia-omniverse.enable {
      environment.systemPackages = [pkgs.nvidia-omniverse];
    })
    (mkIf config.programs.nvtop.enable {
      environment.systemPackages = [pkgs.nvtop];
    })
  ];
}
