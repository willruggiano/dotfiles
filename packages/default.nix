{ inputs }:

final: prev: {
  # TODO: Remove when libcxx-13.0.0 is no longer marked as broken.
  clang-tools-unbroken =
    let
      inherit (inputs.self) lib;
      inherit (prev) llvmPackages_12;
      unwrapped = llvmPackages_12.clang-unwrapped;
    in
    prev.clang-tools.overrideAttrs (_: {
      version = lib.getVersion unwrapped;
      inherit (llvmPackages_12) clang;
      inherit unwrapped;
    });
  cppman = prev.callPackage ./cppman { };
  dummy = prev.runCommand "dummy-0.0.0" { } "mkdir $out";
  firefox-extended = prev.callPackage ./firefox { };
  qutebrowser = prev.qutebrowser.overrideAttrs (_: {
    patches = [
      ./qutebrowser/0001-feat-pass-QUTE_TAB-to-userscripts.patch
    ];
  });
  nonicons = prev.callPackage ./nonicons { };
  nvidia-omniverse = prev.callPackage ./nvidia-omniverse { };
  pass-extension-meta = prev.callPackage ./pass-meta { };
  python39 = prev.python39.override {
    packageOverrides = python-final: python-prev: {
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
  yabai = prev.yabai.overrideAttrs (_: rec {
    version = "3.3.10";
    src = prev.fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = "v${version}";
      hash = "sha256-8O6//T894C32Pba3F2Z84Z6VWeCXlwml3xsXoIZGqL0=";
    };
  });
}
