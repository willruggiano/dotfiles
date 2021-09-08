{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      isort
      pynvim
    ]);
    extraPackages = with pkgs; [
      binutils-unwrapped
      cmake
      clang-tools
      cmake-format
      cmake-language-server
      delta
      fd
      gcc11
      gcc11Stdenv
      gnumake
      ninja
      nixpkgs-fmt
      nodePackages.prettier
      openssl
      python-language-server
      ripgrep
      rnix-lsp
      rustfmt
      unstable.stylua
      sumneko-lua-language-server
      tree-sitter
      yapf
    ];
    extraConfig = ''lua require("bombadil.init")'';
  };

  xdg.configFile = {
    nvim = {
      source = ./config;
      recursive = true;
    };

    "nvim/lua/bombadil/lsp/sumneko.lua" = {
      text = ''
        -- NOTE: This command is a wrapper that includes the -E /path/to/main.lua
        return "${pkgs.sumneko-lua-language-server}/bin/lua-language-server"
      '';
    };
  };
}
