{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.neovim;
in
{
  config = mkIf cfg.enable {
    user.packages = [ pkgs.neovim ];

    home.configFile =
      let
        plugins = import ./plugins pkgs;
        inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;

        mkPlugin = pname: p:
          buildVimPluginFrom2Nix ({ inherit pname; version = "master"; src = p.package; } // (p.override or { }));

        # TODO: Find a better way to deal with rocks which have lua modules
        plugins' = mapAttrs (pname: p: { start = [ (mkPlugin pname p) ] ++ (p.rocks or [ ]); }) plugins;
        rocks = flatten (mapAttrsToList (pname: p: p.rocks or [ ]) plugins);
      in
      {
        nvim = {
          source = ../../../.config/nvim;
          recursive = true;
        };

        "nvim/init.lua".text =
          let
            inherit (pkgs.vimUtils) packDir;

            luaEnv = pkgs.buildEnv {
              name = "neovim-lua-env";
              paths = rocks;
            };

            nodejsEnv = pkgs.buildEnv {
              name = "neovim-nodejs-env";
              paths = with pkgs.nodePackages; [ neovim ];
            };

            pluginEnv = pkgs.buildEnv {
              name = "neovim-plugin-env";
              paths = [ (packDir plugins') ];
            };

            pythonEnv = pkgs.buildEnv {
              name = "neovim-python-env";
              paths = with pkgs; [
                (python310.withPackages (ps: with ps; [ pynvim ]))
              ];
            };
          in
          ''
            -- Generated by Nix
            vim.cmd "set packpath^=${pluginEnv}"
            package.cpath = "${luaEnv}/lib/lua/5.1/?.so" .. ";" .. package.cpath
            vim.cmd "set runtimepath^=${pluginEnv}"

            vim.g.node_host_prog = "${nodejsEnv}/bin/neovim-node-host"
            vim.g.python3_host_prog = "${pythonEnv}/bin/python3"

            require "bombadil"
          '';

        "nvim/plugin/00-setup-plugins.lua".text =
          let
            preloadConfigs = flatten (mapAttrsToList (pname: p: optionals (p ? "setup") [ "-- ${pname}" p.setup ]) plugins);
          in
          concatStringsSep "\n" preloadConfigs;

        "nvim/plugin/01-configure-plugins.lua".text =
          let
            pluginConfigs = flatten (mapAttrsToList (pname: p: optionals (p ? "config") [ "-- ${pname}" p.config ]) plugins);
          in
          concatStringsSep "\n" pluginConfigs;

        "zsh/extra/99-neovim.zsh".text = ''
          if (( ''${+NVIM_LISTEN_ADDRESS} )); then
            alias open="${pkgs.neovim-remote}/bin/nvr -cc quit"
            alias split="${pkgs.neovim-remote}/bin/nvr -cc quit -o"
            alias vsplit="${pkgs.neovim-remote}/bin/nvr -cc quit -O"
          fi
        '';
      };

    home.dataFile = {
      "nvim/site/pack/nix/start/nix/lua/bombadil/generated/lsp.lua".text =
        with pkgs;
        let
          cppEnv = buildEnv {
            name = "neovim-cpp-env";
            paths = [ clang-tools-unbroken cmake-language-server ];
          };

          luaEnv = buildEnv {
            name = "neovim-lua-env";
            paths = with luajitPackages; [ luacheck ] ++ lib.optional stdenv.isLinux sumneko-lua-language-server;
          };

          nixEnv = buildEnv {
            name = "neovim-nix-env";
            paths = [ rnix-lsp ];
          };

          pythonEnv = buildEnv {
            name = "neovim-python-env";
            paths = [
              (python39.withPackages (ps: with ps; [ python-lsp-server pylsp-rope ]))
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
        ] ++ optional stdenv.isDarwin ''
          local sumneko = {
            vim.fn.expand "~/src/lua-language-server/bin/macOS/lua-language-server",
            vim.fn.expand "~/src/lua-language-server/bin/macOS/main.lua"
          }
        '' ++ optional stdenv.isLinux ''
          local sumneko = { "${luaEnv}/bin/lua-language-server" }
        '' ++ [
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
    };

    environment.variables.EDITOR = "nvim";
    environment.variables.MANPAGER = "nvim +Man!";
  };
}
