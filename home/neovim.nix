{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    withNodeJs = true;
    withRuby = true;
    withPython3 = true;

    extraPython3Packages = (ps: with ps; [
      pynvim
    ]);
    extraPackages = with pkgs; [
      (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
    ];

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

  xdg.configFile = {
    # BUG: This one seems to break every once and awhile...
    # "nvim/parser/cpp.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-cpp}/parser";
    # "nvim/parser/java.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-java}/parser";
    "nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
    "nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
    # "nvim/parser/python.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-python}/parser";
  };
}
