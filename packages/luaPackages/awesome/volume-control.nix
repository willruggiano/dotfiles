{
  lua,
  toLuaModule,
  stdenv,
  fetchFromGitHub,
}:
toLuaModule (stdenv.mkDerivation {
  name = "awesome-volume-control";

  src = fetchFromGitHub {
    owner = "deficient";
    repo = "volume-control";
    rev = "a18e8627057228d163e3f9d41902ad9eee566052";
    hash = "sha256-8UqF12b+gJMo/N2ENzvDwFnRdzytYz8eZJ07jleggTk=";
  };

  buildInputs = [lua];

  installPhase = ''
    mkdir -p $out/lib/lua/${lua.luaversion}
    cp volume-control.lua $out/lib/lua/${lua.luaversion}/volume-control.lua
  '';
})
