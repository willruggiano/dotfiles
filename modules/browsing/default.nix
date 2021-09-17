{ options, config, pkgs, lib, ... }:

with lib;
with lib.my;

let cfg = config.modules.browsing;
in
{
  options.modules.browsing = {
    enable = mkBoolOpt false;
    browser = mkOpt types.package pkgs.firefox;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      firefox
    ];
  };
}
