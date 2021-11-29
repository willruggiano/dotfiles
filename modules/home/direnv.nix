{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.direnv;
in
{
  config = mkIf cfg.enable {
    programs.direnv.nix-direnv.enable = true;
    # programs.direnv.nix-direnv.enableFlakes = true;
  };
}
