{ options, config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.emanote;
in
{
  options = {
    programs.emanote = {
      enable = mkEnableOption "Enable emanote";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.emanote ];
  };
}
