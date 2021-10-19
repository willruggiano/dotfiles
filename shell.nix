{ pkgs ? import <nixpkgs> { } }:

with pkgs;
let nixBin =
  writeShellScriptBin "nix" ''
    ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in
mkShell {
  name = "dotfiles";
  buildInputs = [
    fup-repl
    git
    nix-zsh-completions
  ];
  shellHook = ''
    export FLAKE="$(pwd)"
    export PATH="$FLAKE/bin:${nixBin}/bin:$PATH"
  '';
}
