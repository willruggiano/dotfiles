{
  config,
  pkgs,
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
    initialPassword = "password";
    home = "/home/${name}";
    shell = pkgs.zsh;
  };

  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAIngPgrqRfYi/YTrd0+eVRbylSL+weBTtL819GgXUb bombadil@ecthelion";

  hardware.pulseaudio.enable = true;

  programs.kitty.enable = true;
  programs.neovim.enable = true;
  programs.qutebrowser.enable = true;
  programs.qutebrowser.default = true;
  programs.sway.enable = true;

  services.dunst.enable = true;
  services.interception-tools.enable = true;
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];
}
