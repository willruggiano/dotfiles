{
  lua,
  toLuaModule,
  stdenv,
  fetchFromGitHub,
}:
toLuaModule (stdenv.mkDerivation {
  name = "awesome-widgets";

  src = fetchFromGitHub {
    owner = "streetturtle";
    repo = "awesome-wm-widgets";
    rev = "8439ca7930e73e17746a1d6f0610417e8a42865f";
    hash = "sha256-rIp+cpiY0GBvA5nUpMb/6lr+p5jv0/7mlCrVD/RzVsk=";
  };

  buildInputs = [lua];

  installPhase = ''
    mkdir -p $out/lib/lua/${lua.luaversion}
    cp -r . $out/lib/lua/${lua.luaversion}/awesome-wm-widgets
  '';
})
