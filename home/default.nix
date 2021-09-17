{ config, pkgs, lib, ... }:

{
  imports = [
    ./development.nix
    ./fzf.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./shell.nix
  ];

  fonts.fontconfig.enable = true;
}
