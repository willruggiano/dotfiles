{
  fetchFromGitHub,
  fetchgit,
  fetchurl,
  callPackage,
  ...
}: {
  lua-awesome = callPackage ./awesome {};
  # lua-awesome = callPackage ({
  #   toLuaModule,
  #   lua,
  #   luaOlder,
  #   inspect,
  #   lua-lush,
  #   stdenv,
  # }:
  #   toLuaModule (stdenv.mkDerivation rec {
  #     pname = "awesome";
  #     version = "dev";
  #     src = ./awesome;

  #     disabled = luaOlder "5.1";
  #     buildInputs = [lua];
  #     propagatedBuildInputs = [inspect lua-lush];

  #     installPhase = let
  #       libpath = "$out/share/lua/${lua.luaversion}";
  #     in ''
  #       mkdir -p ${libpath}
  #       cp -r lua/* ${libpath}
  #     '';

  #     passthru.nvim-plugin = stdenv.mkDerivation {
  #       name = "${pname}.nvim";
  #       src = ./awesome;
  #       installPhase = ''
  #         mkdir -p $out
  #         cp -r lua $out/
  #         cp -r colors $out/
  #       '';
  #     };
  #   })) {};

  lua-awesome-volume-control = callPackage ./awesome/volume-control.nix {};
  # lua-awesome-volume-control = callPackage ({
  #   toLuaModule,
  #   lua,
  #   luaOlder,
  #   stdenv,
  # }:
  #   toLuaModule (stdenv.mkDerivation {
  #     name = "awesome-volume-control";
  #     src = fetchFromGitHub {
  #       owner = "deficient";
  #       repo = "volume-control";
  #       rev = "a18e8627057228d163e3f9d41902ad9eee566052";
  #       hash = "sha256-8UqF12b+gJMo/N2ENzvDwFnRdzytYz8eZJ07jleggTk=";
  #     };

  #     disabled = luaOlder "5.1";
  #     buildInputs = [lua];

  #     installPhase = ''
  #       mkdir -p $out/lib/lua/${lua.luaversion}
  #       cp volume-control.lua $out/lib/lua/${lua.luaversion}/volume-control.lua
  #     '';
  #   })) {};

  lua-awesome-widgets = callPackage ./awesome/widgets.nix {};
  # lua-awesome-widgets = callPackage ({
  #   toLuaModule,
  #   lua,
  #   luaOlder,
  #   stdenv,
  # }:
  #   toLuaModule (stdenv.mkDerivation {
  #     name = "awesome-widgets";
  #     src = fetchFromGitHub {
  #       owner = "streetturtle";
  #       repo = "awesome-wm-widgets";
  #       rev = "8439ca7930e73e17746a1d6f0610417e8a42865f";
  #       hash = "sha256-rIp+cpiY0GBvA5nUpMb/6lr+p5jv0/7mlCrVD/RzVsk=";
  #     };

  #     disabled = luaOlder "5.1";
  #     buildInputs = [lua];

  #     installPhase = ''
  #       mkdir -p $out/lib/lua/${lua.luaversion}
  #       cp -r . $out/lib/lua/${lua.luaversion}/awesome-wm-widgets
  #     '';
  #   })) {};

  lua-date = callPackage ./date.nix {};
  # lua-date = callPackage ({
  #   buildLuarocksPackage,
  #   luaOlder,
  #   lua,
  # }:
  #   buildLuarocksPackage rec {
  #     pname = "date";
  #     version = "2.2-2";

  #     knownRockspec =
  #       (fetchurl {
  #         url = "mirror://luarocks/date-${version}.rockspec";
  #         hash = "sha256-PdCQinv7JnSoP1YvgD2Y7hhUr9u0ak//6G1m1zNZT3w=";
  #       })
  #       .outPath;
  #     src = fetchFromGitHub {
  #       owner = "Tieske";
  #       repo = "date";
  #       rev = "e5d38bb4e8b8d258d4fc07f3423aa0ac8d1deb6f";
  #       hash = "sha256-Tjyyw+iLN9SMQn8A3S/Z73zN6mrNvSBcLlqJrk8IoLw=";
  #     };
  #     disabled = luaOlder "5.1";
  #     propagatedBuildInputs = [lua];
  #   }) {};

  lua-dbus-proxy = callPackage ./dbus-proxy.nix {};
  # lua-dbus-proxy = callPackage ({
  #   buildLuarocksPackage,
  #   lua,
  #   luaOlder,
  #   lgi,
  # }: rec {
  #   pname = "dbus-proxy";
  #   version = "0.10.2-1";

  #   knownRockspec =
  #     (fetchurl {
  #       url = "mirror://luarocks/dbus_proxy-${version}.rockspec";
  #       hash = "sha256-UL14viaUIVnhwF+X+eENdl1wOjPZqeAotKqpSUTI8ik=";
  #     })
  #     .outPath;
  #   src = fetchFromGitHub {
  #     owner = "stefano-m";
  #     repo = "lua-dbus_proxy";
  #     rev = "7ffddc07acbed4c92004d310e067e9e6b74b4262";
  #     hash = "sha256-1MCqcm4bfPAXDIPwkBYrq65A3V9sFPc/1fXO8IJziE4=";
  #   };

  #   disabled = luaOlder "5.1";
  #   propagatedBuildInputs = [lua lgi];
  # }) {};

  lua-fun = callPackage ./luafun.nix {};
  # lua-fun = callPackage ({
  #   buildLuarocksPackage,
  #   lua,
  #   luaOlder,
  # }:
  #   buildLuarocksPackage rec {
  #     pname = "fun";
  #     version = "scm-1";

  #     knownRockspec =
  #       (fetchurl {
  #         url = "mirror://luarocks/fun-${version}.rockspec";
  #         hash = "sha256-35RcuCYBf5nSO65qBYLYNWmRCaCbFqQdXrk3wBy/lQU=";
  #       })
  #       .out;

  #     src = fetchFromGitHub {
  #       owner = "luafun";
  #       repo = "luafun";
  #       rev = "cb6a7e25d4b55d9578fd371d1474b00e47bd29f3";
  #       hash = "sha256-lqWTPn1HPQxhfkUFvEUCbS05IkkroaykgYehJqQ0+lw=";
  #     };

  #     disabled = luaOlder "5.1";
  #     propagatedBuildInputs = [lua];
  #   }) {};

  lua-http-parser = callPackage ./http-parser.nix {};
  # lua-http-parser = callPackage ({
  #   buildLuarocksPackage,
  #   lua,
  #   luaOlder,
  # }:
  #   buildLuarocksPackage rec {
  #     pname = "fun";
  #     version = "scm-1";

  #     knownRockspec =
  #       (fetchurl {
  #         url = "mirror://luarocks/fun-${version}.rockspec";
  #         hash = "sha256-35RcuCYBf5nSO65qBYLYNWmRCaCbFqQdXrk3wBy/lQU=";
  #       })
  #       .out;

  #     src = fetchFromGitHub {
  #       owner = "luafun";
  #       repo = "luafun";
  #       rev = "cb6a7e25d4b55d9578fd371d1474b00e47bd29f3";
  #       hash = "sha256-lqWTPn1HPQxhfkUFvEUCbS05IkkroaykgYehJqQ0+lw=";
  #     };

  #     disabled = luaOlder "5.1";
  #     propagatedBuildInputs = [lua];
  #   }) {};

  lua-lush = callPackage ./lush.nix {};
  # lua-lush = callPackage ({
  #   toLuaModule,
  #   lua,
  #   stdenv,
  #   luaOlder,
  # }: let
  #   src = fetchFromGitHub {
  #     owner = "willruggiano";
  #     repo = "lush.nvim";
  #     rev = "8100da101761709e1f7b44087b24bb6ebbc8349d";
  #     hash = "sha256-2tMO0D9b5vbveP2K4NJ4QkCvhF4nZTqH1WblhyVEIxs=";
  #   };
  # in
  #   toLuaModule (stdenv.mkDerivation {
  #     name = "lush";
  #     inherit src;

  #     disabled = luaOlder "5.1";
  #     buildInputs = [lua];

  #     installPhase = let
  #       libpath = "$out/share/lua/${lua.luaversion}";
  #     in ''
  #       mkdir -p ${libpath}
  #       cp -r lua/* ${libpath}
  #     '';

  #     passthru.nvim-plugin = stdenv.mkDerivation {
  #       name = "lush.nvim";
  #       inherit src;

  #       installPhase = ''
  #         mkdir -p $out
  #         cp -r doc $out/
  #         cp -r lua $out/
  #         cp -r plugin $out/
  #       '';
  #     };
  #   })) {};

  lua-openssl = callPackage ./openssl.nix {};
  # lua-openssl = callPackage ({
  #   buildLuarocksPackage,
  #   lua,
  #   openssl,
  #   luaOlder,
  # }: let
  #   owner = "zhaozg";
  #   repo = "lua-openssl";
  # in
  #   buildLuarocksPackage rec {
  #     pname = "openssl";
  #     version = "0.8.2-1";
  #     knownRockspec =
  #       (fetchurl {
  #         url = "https://luarocks.org/manifests/${owner}/openssl-${version}.rockspec";
  #         hash = "sha256-gZ4cagPnD+xCjO1WmCntecSsxGHENKQY1AdbHsw+0cs=";
  #       })
  #       .outPath;

  #     src = fetchFromGitHub {
  #       inherit owner repo;
  #       rev = version;
  #       hash = "sha256-8vEBknfKmlu2bxNEoUFHo1mIPl7SSpsFbNW4v+XWjII=";
  #       fetchSubmodules = true;
  #     };

  #     disabled = luaOlder "5.1";
  #     buildInputs = [openssl];
  #     propagatedBuildInputs = [lua];
  #   }) {};

  lua-shipwright = callPackage ./shipwright.nix {};
  # lua-shipwright = callPackage ({
  #   buildLuaPackage,
  #   lua,
  #   luaOlder,
  # }:
  #   buildLuaPackage {
  #     pname = "shipwright";
  #     version = "master";

  #     src = fetchFromGitHub {
  #       owner = "rktjmp";
  #       repo = "shipwright.nvim";
  #       rev = "ab70e80bb67b7ed3350bec89dd73473539893932";
  #       hash = "sha256-Gy0tIqH1dmZgcUvrUcNrqpMXi3gOgHq9X1SbjIZqSns=";
  #     };

  #     disabled = luaOlder "5.1";
  #     propagatedBuildInputs = [lua];

  #     dontBuild = true;

  #     installPhase = ''
  #       runHook preInstall
  #       mkdir -p $out/share/lua
  #       cp -r lua $out/share/lua/${lua.luaversion}
  #       runHook postInstall
  #     '';
  #   }) {};

  luarocks-fetch-gitrec = callPackage ./luarocks-fetch-gitrec.nix {};
  # luarocks-fetch-gitrec = callPackage ({
  #   buildLuarocksPackage,
  #   lua,
  #   luaOlder,
  # }: let
  #   owner = "siffiejoe";
  #   repo = "luarocks-fetch-gitrec";
  # in
  #   buildLuarocksPackage rec {
  #     pname = repo;
  #     version = "0.2-2";
  #     knownRockspec =
  #       (fetchurl {
  #         url = "https://luarocks.org/manifests/${owner}/${repo}-${version}.rockspec";
  #         hash = "sha256-r+RXKwerP627mD+ULaIf3vTtmVo6US6YSRxBN+cbc/Y=";
  #       })
  #       .outPath;

  #     src = fetchFromGitHub {
  #       inherit owner repo;
  #       rev = "v0.2";
  #       hash = "sha256-woek+6N/bz54YU6Q5sDqW9uCgjZqVNvNAsacT8pI50w=";
  #     };

  #     disabled = luaOlder "5.1";
  #     propagatedBuildInputs = [lua];
  #   }) {};
}
