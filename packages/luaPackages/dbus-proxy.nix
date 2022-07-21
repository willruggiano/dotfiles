{
  buildLuarocksPackage,
  fetchFromGitHub,
  fetchurl,
  lua,
  lgi,
}:
buildLuarocksPackage rec {
  pname = "dbus-proxy";
  version = "0.10.2-1";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/dbus_proxy-${version}.rockspec";
      hash = "sha256-UL14viaUIVnhwF+X+eENdl1wOjPZqeAotKqpSUTI8ik=";
    })
    .outPath;
  src = fetchFromGitHub {
    owner = "stefano-m";
    repo = "lua-dbus_proxy";
    rev = "7ffddc07acbed4c92004d310e067e9e6b74b4262";
    hash = "sha256-1MCqcm4bfPAXDIPwkBYrq65A3V9sFPc/1fXO8IJziE4=";
  };

  propagatedBuildInputs = [lua lgi];
}
