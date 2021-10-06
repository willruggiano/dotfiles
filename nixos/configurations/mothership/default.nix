{ pkgs, config, lib, ... }:

with lib;
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./security.nix
  ];

  time.timeZone = mkDefault "America/Denver";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  user.shell = pkgs.zsh;

  modules = {
    browsing = {
      qutebrowser.enable = true;
    };

    hardware = {
      audio.enable = true;
    };

    services = {
      agenix.enable = true;
      gpg = {
        enable = true;
        enablePass = true;
      };
      ssh.enable = true;
    };

    terminal.kitty.enable = true;
  };

  services.xserver.enable = true;
}
