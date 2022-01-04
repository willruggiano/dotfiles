{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.flux;
in
{
  options.programs.flux = {
    enable = mkEnableOption "Enable flux";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [ "flux" ];
  };
}
