{ lib, stdenv, fetchurl }:

let
  docsets = {
    C = {
      url = "http://sanfrancisco.kapeli.com/feeds/C.tgz";
      hash = "sha256-pEGK9wKQesMngyEDJ3k+aD2756oHZMLokQ6nZbYo5/s=";
    };
    "C++" = {
      url = "http://sanfrancisco.kapeli.com/feeds/C++.tgz";
      hash = "sha256-OPZJSdM1BzbEwP5b+PGbzgBFc6nACCnBWcZEAgcgNmM=";
    };
    CMake = {
      url = "http://sanfrancisco.kapeli.com/feeds/CMake.tgz";
      hash = "sha256-Yb8HrS+K4lhRkWW1Fwk5Sqm3FJSb5pJNIX5u3d9PMfs=";
    };
    Lua = {
      url = "http://sanfrancisco.kapeli.com/feeds/Lua_5.4.tgz";
      hash = "sha256-3OujaGyLh2HjK0zvhDY/yoaH8MjszNBey6uaWFNhGLE=";
    };
    "Python 3" = {
      url = "http://sanfrancisco.kapeli.com/feeds/Python_3.tgz";
      hash = "sha256-++PwGO5/28nnUAbzO70IcLZEHsoEFIRm2xm1Lz+R/fk=";
    };
    Qt = {
      url = "http://sanfrancisco.kapeli.com/feeds/Qt_5.tgz";
      hash = "sha256-h9VSoAiqB46yWUgjgCFfHW/46E/X6O9cbKp3thNSwoI=";
    };
  };
in
stdenv.mkDerivation {
  name = "docsets";

  srcs = lib.mapAttrsToList (lang: attrs: fetchurl { inherit (attrs) url hash; }) docsets;
  sourceRoot = ".";

  installPhase = lib.concatStringsSep "\n" [
    "mkdir -p $out/share/docsets"
    (lib.concatMapStringsSep
      "\n"
      (lang: ''cp -r "${lang}.docset" $out/share/docsets/'')
      (builtins.attrNames docsets))
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
}
