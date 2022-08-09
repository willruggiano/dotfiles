{
  lib,
  writeShellApplication,
  lua,
  luaPackages,
  stdenvNoCC,
}: let
  luaEnv = lua.withPackages (ps: with ps; with luaPackages; [argparse inspect lua-awesome lua-toml lua-shipwright stdlib]);
in
  writeShellApplication {
    name = "colorctl";
    runtimeInputs = [luaEnv];
    text = ''
      lua ${./.}/colorctl.lua "$@"
    '';
  }
