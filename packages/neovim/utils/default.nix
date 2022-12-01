{
  config,
  lib,
  pkgs,
  stdenv,
  ...
}: let
in
  stdenv.mkDerivation {
    name = "neovim-utils";

    passthru.lib = import ./lib {inherit lib pkgs;};
  }
