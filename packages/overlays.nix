let
  overrideLua = luaPackages:
    luaPackages.override {
      overrides = final: prev: {
        lua-awesome = prev.callPackage ./luaPackages/awesome {};
        lua-awesome-volume-control = prev.callPackage ./luaPackages/awesome/volume-control.nix {};
        lua-awesome-widgets = prev.callPackage ./luaPackages/awesome/widgets.nix {};
        lua-date = prev.callPackage ./luaPackages/date.nix {};
        lua-http-parser = prev.callPackage ./luaPackages/http-parser.nix {};
        lua-lush = prev.callPackage ./luaPackages/lush.nix {};
        lua-openssl = prev.callPackage ./luaPackages/openssl.nix {};
        luarocks-fetch-gitrec = prev.callPackage ./luaPackages/luarocks-fetch-gitrec.nix {};
      };
    };
in
  final: prev: {
    inherit (final.luaPackages) lua-awesome;
    autorandr-rs = prev.callPackage ./autorandr-rs {};
    circle = prev.callPackage ./circle {};
    docsets = prev.callPackage ./docsets {};
    dummy = prev.runCommand "dummy-0.0.0" {} "mkdir $out";
    firefox-extended = prev.callPackage ./firefox {};
    firenvim = (prev.callPackage ./firenvim {}).package;
    html2text = prev.callPackage ./html2text {};
    keyd = prev.callPackage ./keyd {};
    luaPackages = overrideLua prev.luaPackages;
    luajitPackages = overrideLua prev.luajitPackages;
    neovim-custom = final.neovim.overrideAttrs (attrs: {
      patches = attrs.patches ++ [./neovim/17446.diff];
    });
    neovim-remote = prev.callPackage ./neovim-remote {};
    nonicons = prev.callPackage ./nonicons {};
    nvidia-omniverse = prev.callPackage ./nvidia-omniverse {};
    nvim-treesitter = prev.callPackage ./nvim-treesitter {};
    pass-extension-clip = prev.callPackage ./pass-clip {};
    pass-extension-meta = prev.callPackage ./pass-meta {};
    python3 = prev.python3.override {
      packageOverrides = python-final: python-prev: rec {
        pylsp-rope = prev.callPackage ./python-lsp-server/pylsp-rope.nix {
          inherit (python-prev) buildPythonPackage pythonOlder pytestCheckHook mock;
          inherit (python-final) python-lsp-server rope;
        };
        python-lsp-server = prev.callPackage ./python-lsp-server {inherit (python-prev) python-lsp-server fetchPypi setuptools-scm;};
        rope = prev.callPackage ./python-lsp-server/rope.nix {inherit (python-prev) buildPythonPackage pytestCheckHook;};
      };
    };
    xplr = prev.callPackage ./xplr {};
  }
