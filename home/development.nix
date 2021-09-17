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
    llvmPackages.libcxx

    # Json
    nodePackages.prettier

    # Lua
    stylua
    sumneko-lua-language-server

    # Nix
    nixpkgs-fmt
    rnix-lsp-master

    # Python
    python39Packages.isort
    python-language-server
    yapf
  ];
}
