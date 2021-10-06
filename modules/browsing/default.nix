{ options, config, pkgs, lib, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.browsing;
in
{
  options.modules.browsing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      my.firefox
    ];
  };
}
