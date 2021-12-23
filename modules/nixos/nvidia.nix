{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.nvidia;
in
{
  options.programs.nvidia = {
    enable = mkEnableOption "Nvidia omniverse";
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.nvidia-omniverse ];
  };
}
