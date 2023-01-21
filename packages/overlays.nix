let
  overrideLua = prev: lua:
    lua.pkgs.override {
      overrides = luafinal: luaprev: prev.callPackage ./luaPackages {inherit (luafinal) callPackage;};
    };
in
  final: prev: {
    colorctl = prev.callPackage ./colorctl {
      lua = prev.luajit;
      luaPackages = final.luajitPackages;
      inherit (prev.luajitPackages) toLuaModule;
    };
    autorandr-rs = prev.callPackage ./autorandr-rs {};
    circle = prev.callPackage ./circle {};
    docsets = prev.callPackage ./docsets {};
    dummy = prev.runCommand "dummy-0.0.0" {} "mkdir $out";
    firefox-extended = prev.callPackage ./firefox {};
    firenvim = (prev.callPackage ./firenvim {}).package;
    goxlr = prev.callPackage ./goxlr {};
    html2text = prev.callPackage ./html2text {};
    luaPackages = overrideLua prev prev.lua;
    luajitPackages = overrideLua prev prev.luajit;
    marksman = prev.callPackage ./marksman {};
    neovim-utils = prev.callPackage ./neovim/utils {};
    neovim-remote = prev.callPackage ./neovim-remote {};
    nonicons = prev.callPackage ./nonicons {};
    nvidia-omniverse = prev.callPackage ./nvidia-omniverse {};
    nvim-treesitter = prev.callPackage ./nvim-treesitter {};
    pass-extension-clip = prev.callPackage ./pass-clip {};
    pass-extension-meta = prev.callPackage ./pass-meta {};
    pre-commit-hooks = prev.callPackage ./pythonPackages/pre-commit-hooks.nix {inherit (prev.python3.pkgs) buildPythonPackage pytestCheckHook pythonOlder ruamel-yaml tomli;};
    spotifyd = prev.spotifyd.override (_: {withMpris = true;});
    src-cli = prev.callPackage ./sourcegraph {};
    xplr = prev.callPackage ./xplr {};
  }
