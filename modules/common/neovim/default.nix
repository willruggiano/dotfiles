{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.neovim;
in {
  config = let
    neovim = pkgs.neovim-utils.lib.buildEnv {
      pkg = pkgs.neovim-custom;
      moduleName = "bombadil";
      lua = [pkgs.luajitPackages.luautf8];
      python = [pkgs.python3Packages.py-tree-sitter];
      plugins = import ./plugins {inherit lib pkgs;};
      paths = with pkgs; [
        # Docsets
        dasht
        (lib.optionals stdenv.isLinux elinks)
        # C++
        clang-tools_14
        cmake-language-server
        cppcheck
        # Json
        nodePackages.jsonlint
        # Lua
        luajitPackages.luacheck
        (lib.optionals stdenv.isLinux sumneko-lua-language-server)
        # Nix
        nil
        # Python
        nodePackages.pyright
        # Rust
        rust-analyzer
        # Zig
        zls
      ];
    };
  in
    mkIf cfg.enable {
      user.packages = [neovim];

      home.configFile = {
        nvim = {
          source = ../../../.config/nvim;
          recursive = true;
        };

        "nvim/plugin/00-setup-plugins.lua".text = let
          preloadConfigs =
            [
              ''
                local impatient = require "impatient"
                impatient.enable_profile()
              ''
            ]
            ++ flatten (mapAttrsToList (pname: p: optionals (p ? "setup") ["-- ${pname}" p.setup]) neovim.plugins);
        in
          concatStringsSep "\n" preloadConfigs;

        "nvim/plugin/01-configure-plugins.lua".text = let
          pluginConfigs = flatten (mapAttrsToList (pname: p: optionals (p ? "config") ["-- ${pname}" p.config]) neovim.plugins);
        in
          concatStringsSep "\n" pluginConfigs;

        "zsh/extra/19-neovim.zsh".text = ''
          if (( ''${+NVIM} )); then
            export MANPAGER="${pkgs.neovim-remote}/bin/nvr -c 'Man!' -o -"
            alias edit="${pkgs.neovim-remote}/bin/nvr -cc quit"
            alias split="${pkgs.neovim-remote}/bin/nvr -cc quit -o"
            alias vsplit="${pkgs.neovim-remote}/bin/nvr -cc quit -O"
          fi
        '';
      };

      home.dataFile = {
        "nvim/rplugin.vim".source = neovim.rplugin;
      };

      environment.variables.EDITOR = "nvim";
      environment.variables.MANPAGER = "nvim +Man!";
    };
}
