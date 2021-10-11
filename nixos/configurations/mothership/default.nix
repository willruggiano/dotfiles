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
      qutebrowser = {
        enable = true;
        default = true;
      };
    };

    desktop = {
      discord.enable = true;
      i3.enable = true;
      libreoffice.enable = true;
    };

    hardware = {
      audio.enable = true;
    };

    services = {
      agenix.enable = true;
      dropbox.enable = true;
      gpg = {
        enable = true;
        enablePass = true;
      };
      ssh.enable = true;
    };

    terminal = {
      kitty.enable = true;
      email.enable = true;
    };
  };
}
