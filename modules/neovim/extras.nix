{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.neovim.extras;
  nvr = "${pkgs.neovim-remote}/bin/nvr";
in {
  # TODO: nvr aliases
}
