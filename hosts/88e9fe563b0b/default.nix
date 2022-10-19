{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./networking.nix
  ];

  user.home = "/Users/wruggian";
  user.name = "wruggian";
  user.shell = pkgs.zsh;

  programs.aws.enable = true;
  programs.code.enable = true;
  programs.colorctl.enable = true;
  programs.docker.enable = true;
  programs.docsets.enable = true;
  programs.firefox.enable = true;
  programs.karabiner.enable = true;
  programs.keeping-you-awake.enable = true;
  programs.kitty.enable = true;
  programs.neovim.enable = true;
  programs.qutebrowser = {
    enable = true;
    default = true;
  };
  programs.rdp.enable = true;
  programs.tigervnc.enable = true;
  programs.xplr.enable = true;
  programs.xquartz.enable = true;
  programs.zk.enable = true;
  programs.zsh.enable = true; # We need this so zsh works correctly, even though we configure it through home-manager

  services.yabai-homebrew.enable = true;
}
