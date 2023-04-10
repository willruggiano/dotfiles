{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./i18n.nix
    ./keyboard-layout.nix
    ./networking.nix
    ./security.nix
  ];

  user = rec {
    name = "bombadil";
    initialPassword = name;
    home = "/home/${name}";
    shell = pkgs.fish;
  };

  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAIngPgrqRfYi/YTrd0+eVRbylSL+weBTtL819GgXUb bombadil@ecthelion";

  programs.brave.enable = true;
  programs.brave.default = true;
  programs.browserpass.enable = true;
  programs.blender.enable = true;
  programs.discord.enable = true;
  programs.docsets.enable = true;
  programs.flavours.enable = true;
  programs.fish.enable = true;
  programs.fzf.enable = true;
  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
  };
  programs.kitty.enable = true;
  programs.nvtop.enable = true;
  programs.qutebrowser.enable = true;
  programs.slack.enable = true;
  programs.sourcegraph.enable = true;
  programs.spotify.enable = true;
  programs.starship.enable = true;
  programs.taskwarrior.enable = true;
  programs.xplr.enable = true;
  programs.zk.enable = true;

  services.agenix.enable = true;
  services.autorandrd = {
    enable = true;
    config = ./monitor-layout.kdl;
  };
  services.dunst.enable = true;
  services.pcscd.enable = true;
  services.pipewire.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  virtualisation.docker.enable = true;
}
