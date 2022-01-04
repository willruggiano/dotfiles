{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.firefox;
in
{
  options.programs.firefox = {
    enableViaHomebrew = mkEnableOption "Enable firefox via homebrew";
  };

  config = mkIf cfg.enableViaHomebrew {
    homebrew.casks = [ "firefox" ];
  };
}
