{ config, lib, ... }:

with lib;
let
  brewBinPrefix = "/usr/local/bin";
  cfg = config.homebrew.utilities;
in
{
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
  };
}
