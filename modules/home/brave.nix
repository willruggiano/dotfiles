{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.brave;
in
{
  config = mkIf cfg.enable {
    programs.brave = {
      extensions = [
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
      ];
    };
  };
}
