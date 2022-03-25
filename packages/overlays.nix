final: prev: {
  circle = prev.callPackage ./circle { };
  clang-tools-unbroken =
    let
      inherit (prev) lib;
      inherit (prev) llvmPackages_13;
      unwrapped = llvmPackages_13.clang-unwrapped;
    in
    prev.clang-tools.overrideAttrs (_: {
      version = lib.getVersion unwrapped;
      inherit (llvmPackages_13) clang;
      inherit unwrapped;
    });
  cppman = prev.callPackage ./cppman { };
  docsets = prev.callPackage ./docsets { };
  dummy = prev.runCommand "dummy-0.0.0" { } "mkdir $out";
  firefox-extended = prev.callPackage ./firefox { };
  keyd = prev.callPackage ./keyd { };
  luajitPackages = prev.luajitPackages.override {
    overrides = lua-final: lua-prev: {
      lua-http-parser = lua-prev.callPackage ./luajitPackages/http-parser.nix { };
      lua-openssl = lua-prev.callPackage ./luajitPackages/openssl.nix { };
      luarocks-fetch-gitrec = lua-prev.callPackage ./luajitPackages/luarocks-fetch-gitrec.nix { };
    };
  };
  nonicons = prev.callPackage ./nonicons { };
  nvidia-omniverse = prev.callPackage ./nvidia-omniverse { };
  pass-extension-meta = prev.callPackage ./pass-meta { };
  python39 = prev.python39.override {
    packageOverrides = python-final: python-prev: {
      python-lsp-server = python-prev.python-lsp-server.overrideAttrs (self: rec {
        version = "1.3.3";
        src = prev.fetchFromGitHub {
          owner = "python-lsp";
          repo = self.pname;
          rev = "v${version}";
          hash = "sha256-F8f9NAjPWkm01D/KwFH0oA6nQ3EF4ZVCCckZTL4A35Y=";
        };
      });
      pylsp-rope = prev.callPackage ./python-lsp-server/pylsp-rope.nix { };
      rope = python-prev.rope.overrideAttrs (_: rec {
        version = "0.22.0";
        src = python-prev.fetchPypi {
          pname = "rope";
          inherit version;
          hash = "sha256-sA+8Bkom/GLXIgV4on/WObL61XITZjzDlsE36S1z8Q8=";
        };
        patches = [ ];
      });
    };
  };
  qutebrowser = prev.qutebrowser.overrideAttrs (_: {
    patches = [
      ./qutebrowser/7014.diff
    ];
  });
  yabai = prev.yabai.overrideAttrs (_: rec {
    version = "3.3.10";
    src = prev.fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v${version}";
      hash = "sha256-8O6//T894C32Pba3F2Z84Z6VWeCXlwml3xsXoIZGqL0=";
    };
  });
  zk = prev.zk.overrideAttrs (_: rec {
    version = "0.9.0";
    src = prev.fetchFromGitHub {
      owner = "mickael-menu";
      repo = "zk";
      rev = "v${version}";
      hash = "sha256-AXKIi70evf581lMwfbfxm8hFCzsnhKRQgnIEZQFS75A=";
    };
  });
}
