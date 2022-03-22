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

  # Desktop
  programs.code.enable = true;
  programs.firefox.enable = true;
  programs.qutebrowser = {
    enable = true;
    default = true;
  };
  programs.karabiner.enable = true;
  programs.keeping-you-awake.enable = true;
  # TODO: libcxx-13 is marked as broken
  # programs.slack.enable = true;
  programs.tigervnc.enable = true;
  services.yabai.enable = true;

  # Terminal
  programs.kitty.enable = true;
  programs.neovim.enable = true;
  programs.zsh.enable = true; # We need this so zsh works correctly, even though we configure it through home-manager
  programs.zk.enable = true;
}
