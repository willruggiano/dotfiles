{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.neovim;
in
{
  config = mkIf cfg.enable {
    programs.neovim = {
      package = pkgs.neovim-latest;

      withNodeJs = true;
      withRuby = true;
      withPython3 = true;

      extraPython3Packages = ps: with ps; [ pynvim ];
      extraPackages = with pkgs; [
        clang-tools
        # cmake-language-server
        rnix-lsp
        tree-sitter
        # (tree-sitter.withPlugins (_: tree-sitter.allGrammars))

        # These don't work on macOS yet :(
        (lib.optionals (!stdenv.isDarwin) python39Packages.python-lsp-server)
        (lib.optionals (!stdenv.isDarwin) sumneko-lua-language-server)
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
        source = ../../.config/nvim;
        recursive = true;
      };

      "nvim/lua/bombadil/lsp/sumneko.lua" = {
        text =
          let
            sumneko = with pkgs;
              if stdenv.isDarwin
              then "~/src/lua-language-server/bin/macOS/lua-language-server ~/src/lua-language-server/bin/macOS/main.lua"
              else "${sumneko-lua-language-server}/bin/lua-language-server";
          in
          ''
            -- NOTE: This command is a wrapper that includes the -E /path/to/main.lua
            return "${sumneko}"
          '';
      };
    };
  };
}
