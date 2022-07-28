{
  lib,
  writeShellApplication,
  lua,
  luaPackages,
}: let
  luaEnv = lua.withPackages (ps: with ps; with luaPackages; [argparse lua-awesome lua-shipwright]);
in
  writeShellApplication {
    name = "colorctl";
    runtimeInputs = [luaEnv];
    text = ''
      lua ${./.}/colorctl.lua "$@"
    '';
  }
