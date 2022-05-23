{
  lua,
  toLuaModule,
  stdenv,
  fetchFromGitHub,
}: let
  src = fetchFromGitHub {
    owner = "willruggiano";
    repo = "lush.nvim";
    rev = "8100da101761709e1f7b44087b24bb6ebbc8349d";
    hash = "sha256-2tMO0D9b5vbveP2K4NJ4QkCvhF4nZTqH1WblhyVEIxs=";
  };
in
  toLuaModule (stdenv.mkDerivation {
    name = "lush";
    inherit src;

    buildInputs = [lua];

    installPhase = let
      libpath = "$out/lib/lua/${lua.luaversion}";
    in ''
      mkdir -p ${libpath}
      cp -r lua/* ${libpath}
    '';

    passthru.nvim-plugin = stdenv.mkDerivation {
      name = "lush.nvim";
      inherit src;

      installPhase = ''
        mkdir -p $out
        cp -r doc $out/
        cp -r lua $out/
        cp -r plugin $out/
      '';
    };
  })
