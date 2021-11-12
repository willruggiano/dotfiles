{ config, lib, ... }:

with lib;
let
  brewBinPrefix = "/usr/local/bin";
  cfg = config.homebrew.utilities;
in
{
  options.homebrew.utilities = {
    bartender.enable = mkEnableOption "Enable bartender via homebrew";
    firefox.enable = mkEnableOption "Enable firefox via homebrew";
    flux.enable = mkEnableOption "Enable flux via homebrew";
    rectangle.enable = mkEnableOption "Enable rectangle via homebrew";
  };

  config = {
    environment.shellInit = ''
      eval "$(${brewBinPrefix}/brew shellenv)"
    '';

    homebrew.enable = true;
    homebrew.brewPrefix = brewBinPrefix;
    homebrew.autoUpdate = true;
    homebrew.cleanup = "zap";
    homebrew.global.brewfile = true;
    homebrew.global.noLock = true;

    homebrew.taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

    homebrew.casks = lib.optionals cfg.bartender.enable [ "bartender" ]
      ++ lib.optionals cfg.firefox.enable [ "firefox" ]
      ++ lib.optionals cfg.flux.enable [ "flux" ]
      ++ lib.optionals cfg.rectangle.enable [ "rectangle" ];
  };
}
