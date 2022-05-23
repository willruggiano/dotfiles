{
  buildLuarocksPackage,
  fetchurl,
  fetchFromGitHub,
  lua,
  openssl,
}: let
  owner = "zhaozg";
  repo = "lua-openssl";
in
  buildLuarocksPackage rec {
    pname = "openssl";
    version = "0.8.2-1";
    knownRockspec =
      (fetchurl {
        url = "https://luarocks.org/manifests/${owner}/openssl-${version}.rockspec";
        hash = "sha256-gZ4cagPnD+xCjO1WmCntecSsxGHENKQY1AdbHsw+0cs=";
      })
      .outPath;

    src = fetchFromGitHub {
      inherit owner repo;
      rev = version;
      hash = "sha256-8vEBknfKmlu2bxNEoUFHo1mIPl7SSpsFbNW4v+XWjII=";
      fetchSubmodules = true;
    };

    buildInputs = [openssl];

    propagatedBuildInputs = [lua];
  }
