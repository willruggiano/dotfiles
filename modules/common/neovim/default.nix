{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    user.packages = [pkgs.neovim];

    home.configFile = let
      plugins = import ./plugins {inherit lib pkgs;};
      inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;

      mkPlugin = name: p:
        buildVimPluginFrom2Nix ({
          inherit name;
          src = p.package;
        }
        // (p.override or {}));

      # TODO: Find a better way to deal with rocks which have lua modules
      plugins' = mapAttrs (pname: p: {start = [(mkPlugin pname p)] ++ (p.rocks or []);}) plugins;
      rocks = flatten (mapAttrsToList (pname: p: p.rocks or []) plugins);
    in {
      nvim = {
        source = ../../../.config/nvim;
        recursive = true;
      };

      "nvim/init.lua".text = let
        luaEnv = pkgs.buildEnv {
          name = "neovim-lua-env";
          paths = rocks;
        };

        nodejsEnv = pkgs.buildEnv {
          name = "neovim-nodejs-env";
          paths = with pkgs.nodePackages; [neovim];
        };

        runtimeEnv = pkgs.buildEnv {
          name = "neovim-runtime-env";
          paths = with pkgs.vimUtils; [(packDir plugins')];
        };

        pythonEnv = pkgs.buildEnv {
          name = "neovim-python-env";
          paths = with pkgs; [
            (python3.withPackages (ps: with ps; [pynvim]))
          ];
        };
      in ''
        -- Generated by Nix
        vim.cmd "set packpath^=${runtimeEnv}"
        package.cpath = "${luaEnv}/lib/lua/5.1/?.so" .. ";" .. package.cpath
        vim.cmd "set runtimepath^=${runtimeEnv}"

        vim.g.node_host_prog = "${nodejsEnv}/bin/neovim-node-host"
        vim.g.python3_host_prog = "${pythonEnv}/bin/python3"

        require "bombadil"
      '';

      "nvim/plugin/00-setup-plugins.lua".text = let
        preloadConfigs =
          [
            ''
              local impatient = require "impatient"
              impatient.enable_profile()
            ''
          ]
          ++ flatten (mapAttrsToList (pname: p: optionals (p ? "setup") ["-- ${pname}" p.setup]) plugins);
      in
        concatStringsSep "\n" preloadConfigs;

      "nvim/plugin/01-configure-plugins.lua".text = let
        pluginConfigs = flatten (mapAttrsToList (pname: p: optionals (p ? "config") ["-- ${pname}" p.config]) plugins);
      in
        concatStringsSep "\n" pluginConfigs;

      "zsh/extra/99-neovim.zsh".text = ''
        if (( ''${+NVIM_LISTEN_ADDRESS} )); then
          export MANPAGER="${pkgs.neovim-remote}/bin/nvr -c 'Man!' -o -"
          alias open="${pkgs.neovim-remote}/bin/nvr -cc quit"
          alias split="${pkgs.neovim-remote}/bin/nvr -cc quit -o"
          alias vsplit="${pkgs.neovim-remote}/bin/nvr -cc quit -O"
        fi
      '';
    };

    home.dataFile = {
      "nvim/site/pack/nix/start/nix/lua/bombadil/generated/lsp.lua".text = with pkgs; let
        cppEnv = buildEnv {
          name = "neovim-cpp-env";
          paths = [clang-tools cmake-language-server];
        };

        luaEnv = buildEnv {
          name = "neovim-lua-env";
          paths = with luajitPackages; [luacheck] ++ lib.optional stdenv.isLinux sumneko-lua-language-server;
        };

        nixEnv = buildEnv {
          name = "neovim-nix-env";
          paths = [rnix-lsp];
        };

        pythonEnv = buildEnv {
          name = "neovim-python-env";
          paths = [
            (python3.withPackages (ps: with ps; [python-lsp-server pylsp-rope]))
          ];
        };
      in
        concatStringsSep "\n" ([
          "-- Generated by Nix"
          ''local clangd = { "${cppEnv}/bin/clangd" }''
          ''local cmake = { "${cppEnv}/bin/cmake-language-server" }''
          ''local luacheck = { "${luaEnv}/bin/luacheck" }''
          ''local rnix = { "${nixEnv}/bin/rnix-lsp" }''
          ''local pylsp = { "${pythonEnv}/bin/pylsp" }''
        ]
        ++ optional stdenv.isDarwin ''
          local sumneko = {
            vim.fn.expand "~/src/lua-language-server/bin/macOS/lua-language-server",
            vim.fn.expand "~/src/lua-language-server/bin/macOS/main.lua"
          }
        ''
        ++ optional stdenv.isLinux ''
          local sumneko = { "${luaEnv}/bin/lua-language-server" }
        ''
        ++ [
          ''
            return {
              clangd = clangd,
              cmake = cmake,
              luacheck = luacheck,
              pylsp = pylsp,
              rnix = rnix,
              sumneko = sumneko,
            }
          ''
        ]);
      "nvim/site/pack/nix/start/nix/lua/bombadil/generated/programs.lua".text = with pkgs;
        concatStringsSep "\n" ([
          "-- Generated by Nix"
          ''
            local dasht = {
              query_line = "${dasht}/bin/dasht-query-line",
            }
          ''
        ]
        ++ [
          ''
            return {
              dasht = dasht,
          ''
        ]
        ++ optional stdenv.isLinux ''
          elinks = "${elinks}/bin/elinks",
        ''
        ++ [
          ''
            }
          ''
        ]);
    };

    environment.variables.EDITOR = "nvim";
    environment.variables.MANPAGER = "nvim +Man!";
  };
}
