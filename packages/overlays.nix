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
  python3 = prev.python3.override {
    packageOverrides = python-final: python-prev: {
      python-lsp-server = python-prev.python-lsp-server.overrideAttrs (_: rec {
        version = "1.4.1";
        src = python-final.fetchPypi {
          pname = "python-lsp-server";
          inherit version;
          hash = "sha256-vn+DKYr58JUak5csr8nbBP189cBfIIElFSdfC6cONC8=";
        };
      });
      pylsp-rope = python-final.callPackage ./python-lsp-server/pylsp-rope.nix {};
      rope = python-prev.rope.overrideAttrs (_: rec {
        version = "1.0.0";
        src = python-prev.fetchPypi {
          pname = "rope";
          inherit version;
          hash = "sha256-FvZS0wAilneNRj2zKdpqBdkUpNveMOptp2Ni2gbA67c=";
        };
        patches = [];
      });
    };
  };
}
