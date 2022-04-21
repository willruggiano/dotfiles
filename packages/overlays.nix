final: prev: {
  circle = prev.callPackage ./circle {};
  cppman = prev.callPackage ./cppman {};
  docsets = prev.callPackage ./docsets {};
  dummy = prev.runCommand "dummy-0.0.0" {} "mkdir $out";
  firefox-extended = prev.callPackage ./firefox {};
  firenvim = (prev.callPackage ./firenvim {}).package;
  keyd = prev.callPackage ./keyd {};
  luajitPackages = prev.luajitPackages.override {
    overrides = lua-final: lua-prev: {
      lua-http-parser = lua-prev.callPackage ./luajitPackages/http-parser.nix {};
      lua-openssl = lua-prev.callPackage ./luajitPackages/openssl.nix {};
      luarocks-fetch-gitrec = lua-prev.callPackage ./luajitPackages/luarocks-fetch-gitrec.nix {};
    };
  };
  nonicons = prev.callPackage ./nonicons {};
  nvidia-omniverse = prev.callPackage ./nvidia-omniverse {};
  pass-extension-meta = prev.callPackage ./pass-meta {};
}
