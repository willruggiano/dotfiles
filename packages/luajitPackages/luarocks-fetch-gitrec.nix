{
  buildLuarocksPackage,
  fetchurl,
  fetchFromGitHub,
  lua,
}: let
  owner = "siffiejoe";
  repo = "luarocks-fetch-gitrec";
in
  buildLuarocksPackage rec {
    pname = repo;
    version = "0.2-2";
    knownRockspec =
      (fetchurl {
        url = "https://luarocks.org/manifests/${owner}/${repo}-${version}.rockspec";
        hash = "sha256-r+RXKwerP627mD+ULaIf3vTtmVo6US6YSRxBN+cbc/Y=";
      })
      .outPath;

    src = fetchFromGitHub {
      inherit owner repo;
      rev = "v0.2";
      hash = "sha256-woek+6N/bz54YU6Q5sDqW9uCgjZqVNvNAsacT8pI50w=";
    };

    propagatedBuildInputs = [lua];
  }
