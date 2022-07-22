{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./i18n.nix
    ./networking.nix
    ./security.nix
  ];

  user = rec {
    name = "bombadil";
    initialPassword = name;
    home = "/home/${name}";
    shell = pkgs.zsh;
  };

  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERAQpJ3mjcz+b2Y+Wf598wURIrGU710Sr91HCcwSiXS bombadil@mothership";

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
  programs.taskwarrior.enable = true;
  programs.xplr.enable = true;
  programs.zk.enable = true;

  services.agenix.enable = true;
  # services.autorandrd = {
  #   enable = true;
  #   config = ./monitor-layout.kdl;
  # };
  services.awesome.enable = true;
  services.clipcat.enable = true;
  services.dunst.enable = true;
  services.email.enable = true;
  services.expressvpn.enable = true;
  services.interception-tools.enable = true;
  # services.keyd.enable = true;
  services.pcscd.enable = true;
  services.pipewire.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];
  services.xserver.displayManager.autoLogin.enable = false;

  virtualisation.docker.enable = true;
}
