{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.browsing.firefox;
in
{
  options.modules.browsing.firefox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      my.firefox # Custom firefox with addons
    ];

    # TODO: If/when addons are configurable with nightly (or more current) versions than ESR there will be more configuration to do here!
  };
}
