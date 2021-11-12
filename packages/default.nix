{ inputs }:

final: prev: {
  cppman = prev.callPackage ./cppman { };
  dummy = prev.runCommand "dummy-0.0.0" { } "mkdir $out";
  firefox-extended = prev.callPackage ./firefox { };
  nonicons = prev.callPackage ./nonicons { };
  pass-extension-meta = prev.callPackage ./pass-meta { };
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
