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
    plugins = import ./plugins {inherit lib pkgs;};

    inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    mkPlugin = name: p:
      buildVimPluginFrom2Nix ({
        inherit name;
        src = p.package;
      }
      // (p.override or {}));

    inherit (pkgs.vimUtils) toVimPlugin;
    inherit (pkgs.luajitPackages) luarocksMoveDataFolder;
    lualib = pkgs.luajitPackages.lib;
    buildLuarocksPlugin = originalLuaDrv: let
      luaDrv = lualib.overrideLuarocks originalLuaDrv (drv: {
        extraConfig = ''
          lua_modules_path = "lua"
        '';
      });
    in
      toVimPlugin (luaDrv.overrideAttrs (oa: {
        nativeBuildInputs = oa.nativeBuildInputs or [] ++ [luarocksMoveDataFolder];
      }));

    # TODO: It would be nice for *each* plugin to be its own little Lua env (via buildEnv)
    # and then only expose the lua bits from the primary package.
    # This would make it easy to specify rocks and additional dependencies, while also
    # keeping those guys hidden from the rest of the system. We'd really be creating little sandboxed envs for every plugin.
    plugins' = mapAttrs (pname: p: {start = [(mkPlugin pname p)];}) plugins;
    rocks = flatten (mapAttrsToList (pname: p: p.rocks or []) plugins);
    rocks' =
      mapAttrs (_: p: {start = [(buildLuarocksPlugin p)];})
      (listToAttrs (
        map (p: {
          name = p.pname;
          value = p;
        })
        rocks
      ));

    luaEnv = pkgs.buildEnv {
      name = "neovim-lua-env";
      paths =
        rocks
        ++ (with pkgs.luajitPackages; [
          luautf8
          lua-fun
        ]);
    };

    nodejsEnv = pkgs.buildEnv {
      name = "neovim-nodejs-env";
      paths = with pkgs.nodePackages; [neovim];
    };

    runtimeEnv = pkgs.buildEnv {
      name = "neovim-runtime-env";
      paths = with pkgs.vimUtils; [(packDir plugins') (packDir rocks')];
    };

    pythonEnv = pkgs.buildEnv {
      name = "neovim-python-env";
      paths = with pkgs; [
        (python3.withPackages (ps: with ps; [pynvim py-tree-sitter]))
      ];
    };
  in
    mkIf cfg.enable {
      user.packages = [pkgs.neovim-custom];

      home.configFile = {
        nvim = {
          source = ../../../.config/nvim;
          recursive = true;
        };

        "nvim/init.lua".text = ''
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
        "nvim/rplugin.vim".source = let
          lua-config = pkgs.writeText "init.lua" ''
            vim.cmd "set packpath^=${runtimeEnv}"
            package.cpath = "${luaEnv}/lib/lua/5.1/?.so" .. ";" .. package.cpath
            vim.cmd "set runtimepath^=${runtimeEnv}"
            vim.g.node_host_prog = "${nodejsEnv}/bin/neovim-node-host"
            vim.g.python3_host_prog = "${pythonEnv}/bin/python3"
          '';
          manifest =
            pkgs.runCommand "update-remote-plugins" {
              nativeBuildInputs = with pkgs; [exa neovim-custom];
            } ''
              mkdir $out
              export HOME=$TMP
              export NVIM_RPLUGIN_MANIFEST=$out/rplugin.vim
              nvim --headless -i NONE -n -u ${lua-config} +UpdateRemotePlugins +quit!
            '';
        in "${manifest}/rplugin.vim";

        "nvim/site/pack/nix/start/nix/lua/bombadil/generated/lsp.lua".text = with pkgs; let
          cppEnv = buildEnv {
            name = "neovim-cpp-env";
            paths = [clang-tools_14 cmake-language-server cppcheck];
          };

          luaEnv = buildEnv {
            name = "neovim-lua-env";
            paths = with luajitPackages; [luacheck] ++ lib.optional stdenv.isLinux sumneko-lua-language-server;
          };

          nixEnv = buildEnv {
            name = "neovim-nix-env";
            paths = [nil rnix-lsp];
          };

          nodeEnv = buildEnv {
            name = "neovim-node-env";
            paths = with pkgs.nodePackages; [jsonlint];
          };

          pythonEnv = buildEnv {
            name = "neovim-python-env";
            paths = [nodePackages.pyright];
          };

          rustEnv = buildEnv {
            name = "neovim-rust-env";
            paths = [];
          };

          zigEnv = buildEnv {
            name = "neovim-zig-env";
            paths = with pkgs; [zls];
          };
        in
          concatStringsSep "\n" ([
            "-- Generated by Nix"
            ''local cmake = { "${cppEnv}/bin/cmake-language-server" }''
            ''local cppcheck = "${cppEnv}/bin/cppcheck"''
            ''local jsonlint = "${nodeEnv}/bin/jsonlint"''
            ''local luacheck = { "${luaEnv}/bin/luacheck" }''
            ''local nil_ls = { "${nixEnv}/bin/nil" }''
            ''local rnix = { "${nixEnv}/bin/rnix-lsp" }''
            ''local pylsp = { "${pythonEnv}/bin/pyright" }''
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
                cmake = cmake,
                cppcheck = cppcheck,
                jsonlint = jsonlint,
                luacheck = luacheck,
                nil_ls = nil_ls,
                pylsp = pylsp,
                rnix = rnix,
                ["rust-analyzer"] = rust_analyzer,
                rustfmt = rustfmt,
                sumneko = sumneko,
                zls = zls,
              }
            ''
          ]);

        "nvim/site/pack/nix/start/nix/lua/bombadil/generated/exe.lua".text = with pkgs;
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
