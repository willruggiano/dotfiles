final: prev: {
  circle = prev.callPackage ./circle {};
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
  nvim-treesitter = prev.callPackage ./nvim-treesitter {};
  pass-extension-meta = prev.callPackage ./pass-meta {};
  python3 = prev.python3.override {
    packageOverrides = python-final: python-prev: rec {
      pylsp-rope = prev.callPackage ./python-lsp-server/pylsp-rope.nix {
        inherit (python-prev) buildPythonPackage pythonOlder pytestCheckHook mock;
        inherit (python-final) python-lsp-server rope;
      };
      python-lsp-server = prev.callPackage ./python-lsp-server {inherit (python-prev) python-lsp-server fetchPypi;};
      rope = prev.callPackage ./python-lsp-server/rope.nix {inherit (python-prev) buildPythonPackage pytestCheckHook;};
    };
  };
}
