{
  lib,
  pkgs,
  utils ? pkgs.neovim-utils.lib,
}: {
  pkg ? pkgs.neovim,
  moduleName,
  lua ? [],
  nodejs ? [],
  python ? [],
  plugins ? {},
  paths ? [],
}:
  with lib; let
    inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
    mkPlugin = name: p:
      buildVimPluginFrom2Nix ({
        inherit name;
        src = p.package;
      }
      // (p.override or {}));

    inherit (pkgs.vimUtils) toVimPlugin;
    inherit (pkgs.luajitPackages) luarocksMoveDataFolder;
    lualib = pkgs.luajit.pkgs.luaLib;
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
    rocks = flatten (mapAttrsToList (pname: p: p.rocks or []) plugins) ++ [pkgs.luajitPackages.lua-fun];
    rocks' =
      mapAttrs (_: p: {start = [(buildLuarocksPlugin p)];})
      (listToAttrs (
        map (p: {
          name = p.pname;
          value = p;
        })
        rocks
      ));

    nodejsEnv = pkgs.buildEnv {
      name = "neovim-nodejs-env";
      paths = [pkgs.nodePackages.neovim] ++ nodejs;
    };

    inherit (pkgs.vimUtils) packDir;
    packageEnv = pkgs.buildEnv {
      name = "neovim-package-env";
      paths = lua ++ rocks ++ [(packDir plugins') (packDir rocks')];
    };

    pythonEnv = pkgs.buildEnv {
      name = "neovim-python-env";
      paths = [(pkgs.python3.withPackages (ps: with ps; [pynvim] ++ python))];
    };

    runtimeEnv = pkgs.buildEnv {
      name = "neovim-runtime-env";
      inherit paths;
    };

    initLua = utils.mkInitLua {
      inherit moduleName;
      inherit nodejsEnv packageEnv pythonEnv;
    };

    # NOTE: Almost identical to `writeShellApplication`, except we *append* (rather than prepend) the runtimeInputs to PATH.
    # This allows "default" runtime tools to be overridden by the environment (e.g. use a project specific clangd rather than the default clangd).
    wrapper = pkgs.writeTextFile rec {
      name = "nvim";
      executable = true;
      destination = "/bin/${name}";
      text =
        ''
          #!${pkgs.runtimeShell}
          set -o errexit
          set -o nounset
          set -o pipefail
        ''
        + lib.optionalString (paths != []) ''
          export PATH="$PATH:${runtimeEnv}/bin"
        ''
        + ''
          ${pkg}/bin/nvim -u ${initLua} "$@"
        '';

      checkPhase = ''
        runHook preCheck
        ${pkgs.stdenv.shellDryRun} "$target"
        ${pkgs.shellcheck}/bin/shellcheck "$target"
        runHook postCheck
      '';

      meta.mainProgram = name;
    };
  in
    pkgs.buildEnv {
      name = "neovim-env";
      paths = [wrapper];
      passthru = {
        inherit plugins;
        rplugin = let
          lua-config = pkgs.writeText "init.lua" ''
            vim.cmd "set packpath^=${packageEnv}"
            package.cpath = "${packageEnv}/lib/lua/5.1/?.so" .. ";" .. package.cpath
            vim.cmd "set runtimepath^=${packageEnv}"
            vim.g.node_host_prog = "${nodejsEnv}/bin/neovim-node-host"
            vim.g.python3_host_prog = "${pythonEnv}/bin/python3"
          '';
          manifest =
            pkgs.runCommand "update-remote-plugins" {
              nativeBuildInputs = [pkg];
            } ''
              mkdir $out
              export HOME=$TMP
              export NVIM_RPLUGIN_MANIFEST=$out/rplugin.vim
              nvim --headless -i NONE -n -u ${lua-config} +UpdateRemotePlugins +quit!
            '';
        in "${manifest}/rplugin.vim";
      };
    }
