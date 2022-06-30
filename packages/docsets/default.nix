{
  lib,
  stdenv,
  fetchurl,
}: let
  docsets = {
    C = {
      url = "http://sanfrancisco.kapeli.com/feeds/C.tgz";
      hash = "sha256-yi2uK0gimURYJmxOw+SGOXF5C+9/Ukuhnma1+2CWeNU=";
    };
    "C++" = {
      url = "http://sanfrancisco.kapeli.com/feeds/C++.tgz";
      hash = "sha256-a7K9lo8WX0PEGVN44E1OzCUQCF5ZngxvfhQ1zGl+sA8=";
    };
    CMake = {
      url = "http://sanfrancisco.kapeli.com/feeds/CMake.tgz";
      hash = "sha256-ilukU3e1PHNfyF8T5jBWCENX0S4VfVCoUvprhK9zy7Q=";
    };
    Lua = {
      url = "http://sanfrancisco.kapeli.com/feeds/Lua_5.4.tgz";
      hash = "sha256-3OujaGyLh2HjK0zvhDY/yoaH8MjszNBey6uaWFNhGLE=";
    };
    "Python 3" = {
      url = "http://sanfrancisco.kapeli.com/feeds/Python_3.tgz";
      hash = "sha256-4CLqUsh5CQa2ROAuABhuCPZlWJ8i2IfSsbfgOwSRJrM=";
    };
    Qt = {
      url = "http://sanfrancisco.kapeli.com/feeds/Qt_5.tgz";
      hash = "sha256-sFYf8jb2maTqgvDWW9cCGQIOF/u5oBEF2Jy0mbs54zQ=";
    };
  };
in
  stdenv.mkDerivation {
    name = "docsets";

    srcs = lib.mapAttrsToList (lang: attrs: fetchurl {inherit (attrs) url hash;}) docsets;
    sourceRoot = ".";

    installPhase = lib.concatStringsSep "\n" [
      "mkdir -p $out/share/docsets"
      (lib.concatMapStringsSep
      "\n"
      (lang: ''cp -r "${lang}.docset" $out/share/docsets/${builtins.replaceStrings [" "] [""] lang}.docset'')
      (builtins.attrNames docsets))
    ];

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
  }
