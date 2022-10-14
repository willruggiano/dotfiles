{
  toLuaModule,
  stdenv,
  writeShellApplication,
  lua,
  luaPackages,
}: let
  colorctl = toLuaModule (stdenv.mkDerivation {
    name = "colorctl";
    version = "0.1.0";

    src = ./.;

    propagatedBuildInputs = [lua] ++ (with luaPackages; [argparse inspect lua-awesome lua-shipwright stdlib]);

    installPhase = let
      libpath = "$out/share/lua/${lua.luaversion}";
    in ''
      mkdir -p ${libpath}
      cp -r lua/* ${libpath}
    '';
  });
in
  writeShellApplication {
    name = "colorctl";
    runtimeInputs = [(lua.withPackages (_: [colorctl]))];
    text = ''
      lua ${./.}/colorctl.lua "$@"
    '';
  }
