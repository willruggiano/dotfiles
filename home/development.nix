{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # C/C++
    cmake
    clang-tools
    cmake-format
    # cmake-language-server
    gcc11
    gnumake
    ninja

    # Json
    nodePackages.prettier

    # Lua
    stylua
    sumneko-lua-language-server

    # Nix
    nixpkgs-fmt
    rnix-lsp

    # Python
    (python39.withPackages (ps: with ps; [ isort pipx ]))
    python-language-server
    yapf
  ];
}
