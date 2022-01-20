{ config, lib, pkgs, ... }:

with lib;
{
  imports = [
    ./networking.nix
  ];

  user.home = "/Users/wruggian";
  user.name = "wruggian";
  user.shell = pkgs.zsh;

  # Desktop
  programs.firefox.enableViaHomebrew = true;
  programs.karabiner.enable = true;
  programs.keeping-you-awake.enable = true;
  # TODO: libcxx-13 is marked as broken
  # programs.slack.enable = true;
  services.yabai.enable = true;

  # Terminal
  programs.kitty.enable = true;
  programs.neovim.enable = true;

  # Web browsing
  programs.qutebrowser.enable = true;
  programs.qutebrowser.default = true;
  # programs.firefox.enable = false; # via home.nix
}
