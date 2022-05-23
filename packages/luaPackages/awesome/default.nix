{
  lua,
  toLuaModule,
  stdenv,
  inspect,
  lua-lush,
}: let
  name = "awesome";
  awesome = stdenv.mkDerivation {
    pname = name;
    version = "dev";
    src = ./.;

    buildInputs = [lua];
    propagatedBuildInputs = [inspect lua-lush];

    installPhase = let
      libpath = "$out/lib/lua/${lua.luaversion}";
    in ''
      mkdir -p ${libpath}
      cp -r lua/* ${libpath}
    '';

    passthru.nvim-plugin = stdenv.mkDerivation {
      name = "${name}.nvim";
      src = ./.;
      installPhase = ''
        mkdir -p $out
        cp -r lua $out/
        cp -r colors $out/
      '';
    };
  };
in
  toLuaModule awesome
