{ pkgs, config, lib, ... }:

with lib;

{
  imports = [
    ./drivers.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./security.nix
  ];

  user.home = "/home/bombadil";
  user.name = "bombadil";
  user.shell = pkgs.zsh;
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";

  # Web browsing
  programs.qutebrowser.enable = true;
  programs.qutebrowser.default = true;
  programs.firefox.enable = false; # via home.nix

  # Desktop
  programs.discord.enable = true;
  # programs.i3.enable = true;
  programs.sway.enable = true;
  programs.libreoffice.enable = true;

  # Terminal
  programs.kitty.enable = true;

  # Services
  services.agenix.enable = true;
  services.dropbox.enable = true;
  services.email.enable = true;
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
}
