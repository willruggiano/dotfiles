{ inputs }:

final: prev: {
  cppman = prev.callPackage ./cppman { };
  firefox-extended = prev.callPackage ./firefox { };
  neovim-latest = prev.neovim-unwrapped.overrideAttrs (_: rec {
    version = "0.5.x";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "release-0.5";
      hash = "sha256-8UaMXPFXigjAlDMIf6gfJUvykv/zJc1GuqJsVmhUlj8=";
    };
  });
  nonicons = prev.callPackage ./nonicons { };
  pass-extension-meta = prev.callPackage ./pass-meta { };
}
