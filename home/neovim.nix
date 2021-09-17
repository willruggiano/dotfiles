{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-master;

    withNodeJs = true;

    withRuby = true;

    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      pynvim
    ]);

    extraConfig = ''
      lua require "bombadil"
    '';

    # NOTE: Here we specify some plugins which require special handling, e.g. building shared libraries
    plugins = with pkgs.vimPlugins; [ cpsm ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  xdg.configFile = {
    nvim = {
      source = ../.config/nvim;
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
