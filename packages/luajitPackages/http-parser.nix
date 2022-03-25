{ buildLuarocksPackage, fetchFromGitHub, lua, luarocks-fetch-gitrec }:

buildLuarocksPackage rec {
  pname = "lua-http-parser";
  version = "2.7-1";

  src = fetchFromGitHub {
    owner = "willruggiano";
    repo = "lua-http-parser";
    rev = "10121a052531011c6a94b2a2ed8a964b4926d24a";
    hash = "sha256-oN0cfompO21z6mCfRqNTFSait5TKOcu0lR7YVxotVCQ=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ lua luarocks-fetch-gitrec ];
}
