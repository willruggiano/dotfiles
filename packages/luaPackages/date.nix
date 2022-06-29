{
  buildLuarocksPackage,
  fetchFromGitHub,
  fetchurl,
  lua,
  luarocks-fetch-gitrec,
}:
buildLuarocksPackage rec {
  pname = "date";
  version = "2.2-2";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/date-${version}.rockspec";
      hash = "sha256-PdCQinv7JnSoP1YvgD2Y7hhUr9u0ak//6G1m1zNZT3w=";
    })
    .outPath;
  src = fetchFromGitHub {
    owner = "Tieske";
    repo = "date";
    rev = "e5d38bb4e8b8d258d4fc07f3423aa0ac8d1deb6f";
    hash = "sha256-Tjyyw+iLN9SMQn8A3S/Z73zN6mrNvSBcLlqJrk8IoLw=";
  };

  propagatedBuildInputs = [lua];
}
