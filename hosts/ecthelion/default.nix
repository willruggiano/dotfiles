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
    shell = pkgs.zsh;
  };

  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAIngPgrqRfYi/YTrd0+eVRbylSL+weBTtL819GgXUb bombadil@ecthelion";

  programs.blender.enable = true;
  programs.discord.enable = true;
  programs.docsets.enable = true;
  programs.flavours.enable = true;
  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
    wallpapers = {
      "DP-1" = {
        wallpaper = ../../wallpapers/moria.png;
      };
      "DP-2" = {
        wallpaper = ../../wallpapers/gandalf.jpg;
      };
    };
  };
  programs.kitty.enable = true;
  programs.neovim.enable = true;
  programs.nvtop.enable = true;
  programs.qutebrowser = {
    enable = true;
    default = true;
  };
  programs.sourcegraph.enable = true;
  programs.spotify.enable = true;
  programs.xplr.enable = true;
  programs.zk.enable = true;

  services.agenix.enable = true;
  services.autorandrd = {
    enable = true;
    config = ./monitor-layout.kdl;
  };
  services.clipcat.enable = true;
  services.dunst.enable = true;
  # services.email.enable = true;
  # services.expressvpn.enable = true;
  # services.goxlr.enable = true;
  services.pcscd.enable = true;
  services.pipewire.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  virtualisation.docker.enable = true;
}
