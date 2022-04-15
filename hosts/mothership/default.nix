{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    ./hardware-configuration.nix
    ./i18n.nix
    ./networking.nix
    ./security.nix
  ];

  user.home = "/home/bombadil";
  user.name = "bombadil";
  user.shell = pkgs.zsh;
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;

  programs.discord.enable = true;
  programs.docsets.enable = true;
  programs.firefox.enable = false; # via home.nix
  programs.kitty.enable = true;
  programs.libreoffice.enable = true;
  programs.neovim.enable = true;
  programs.obs-studio.enable = true;
  programs.qutebrowser.default = true;
  programs.qutebrowser.enable = true;
  programs.spotify.enable = true;
  programs.steam.enable = true;
  programs.sway.enable = true;
  programs.taskwarrior.enable = true;
  programs.zk.enable = true;

  services.agenix.enable = true;
  services.dunst.enable = true;
  services.email.enable = true;
  services.expressvpn.enable = true;
  services.interception-tools.enable = true;
  # services.keyd.enable = true;
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enable = true;
}
