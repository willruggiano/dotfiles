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
        lua-shipwright = prev.callPackage ./luaPackages/shipwright.nix {};
        luarocks-fetch-gitrec = prev.callPackage ./luaPackages/luarocks-fetch-gitrec.nix {};
      };
    };
in
  final: prev: {
    # inherit (final.luaPackages) lua-awesome lua-shipwright;
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
    luaPackages = overrideLua prev.luaPackages;
    luajitPackages = overrideLua prev.luajitPackages;
    marksman = prev.callPackage ./marksman {};
    neovim-custom = final.neovim.overrideAttrs (attrs: {
      patches = attrs.patches ++ [./neovim/17446.diff];
    });
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
