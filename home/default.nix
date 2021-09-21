{ config, pkgs, lib, ... }:

{
  imports = [
    ./development.nix
    ./fzf.nix
    ./git.nix
    ./neovim.nix
    ./shell.nix
  ];

  fonts.fontconfig.enable = true;
}
