{
  buildLuaPackage,
  fetchFromGitHub,
  lua,
}:
buildLuaPackage {
  pname = "shipwright";
  version = "master";

  src = fetchFromGitHub {
    owner = "rktjmp";
    repo = "shipwright.nvim";
    rev = "ab70e80bb67b7ed3350bec89dd73473539893932";
    hash = "sha256-Gy0tIqH1dmZgcUvrUcNrqpMXi3gOgHq9X1SbjIZqSns=";
  };

  propagatedBuildInputs = [lua];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/lua
    cp -r lua $out/share/lua/${lua.luaversion}
    runHook postInstall
  '';
}
