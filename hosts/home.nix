{ config, lib, pkgs, ... }:

with lib;
{
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };
  time.timeZone = mkDefault "America/Denver";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
}
