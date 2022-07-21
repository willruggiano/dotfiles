let
  overrideLua = luaPackages:
    luaPackages.override {
      overrides = final: prev: {
        lua-awesome = prev.callPackage ./luaPackages/awesome {};
        lua-awesome-volume-control = prev.callPackage ./luaPackages/awesome/volume-control.nix {};
        lua-awesome-widgets = prev.callPackage ./luaPackages/awesome/widgets.nix {};
        lua-date = prev.callPackage ./luaPackages/date.nix {};
        lua-dbus-proxy = prev.callPackage ./luaPackages/dbus-proxy.nix {};
        lua-fun = prev.callPackage ./luaPackages/luafun.nix {};
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
    pre-commit-hooks = prev.callPackage ./pythonPackages/pre-commit-hooks.nix {inherit (prev.python3.pkgs) buildPythonPackage pytestCheckHook pythonOlder ruamel-yaml tomli;};
    python3 = prev.python3.override {
      packageOverrides = python-final: python-prev: rec {
        pylsp-rope = prev.callPackage ./pythonPackages/python-lsp-server/pylsp-rope.nix {
          inherit (python-prev) buildPythonPackage pythonOlder pytestCheckHook mock;
          inherit (python-final) python-lsp-server rope;
        };
        python-lsp-server = prev.callPackage ./pythonPackages/python-lsp-server {inherit (python-prev) python-lsp-server fetchPypi setuptools-scm;};
        rope = prev.callPackage ./pythonPackages/python-lsp-server/rope.nix {inherit (python-prev) buildPythonPackage pytestCheckHook;};
      };
    };
    spotifyd = prev.spotifyd.override (_: {withMpris = true;});
    src-cli = prev.callPackage ./sourcegraph {};
    xplr = prev.callPackage ./xplr {};
    zig_0_10_0 = prev.zig.overrideAttrs (_: {
      version = "0.10.0";

      src = prev.fetchFromGitHub {
        owner = "ziglang";
        repo = "zig";
        rev = "b9ed07227832a10e5a18667d6c7cbdffd2018da7";
        hash = "sha256-VEMX2SCaaEd6sYJpXxSlmH2gHYj9bzxatkT47/lszoA=";
      };

      nativeBuildInputs = with prev; [cmake llvmPackages_14.llvm.dev];
      buildInputs = with prev; [libxml2 zlib] ++ (with prev.llvmPackages_14; [libclang lld llvm]);

      cmakeFlags = ["-DZIG_STATIC_ZLIB=ON"];
    });
    zigmod = prev.callPackage ./zigmod {};
  }
