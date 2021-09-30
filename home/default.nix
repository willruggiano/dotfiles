{ config, pkgs, lib, ... }:

{
  imports = [
    ./development.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./shell.nix
  ];

  fonts.fontconfig.enable = true;
}
