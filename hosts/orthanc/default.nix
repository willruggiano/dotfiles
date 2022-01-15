{ config, lib, pkgs, ... }:

with lib;
{
  imports = [
    ./hardware-configuration.nix
    ./i18n.nix
  ];

  user.home = "/home/saruman";
  user.name = "saruman";
  user.shell = pkgs.zsh;
}
