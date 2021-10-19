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
      hash = "sha256-95Vfg8yp+ga6I+oqR+sE1+qOi4sR6NV1eLv9xYzwTeY=";
    };
  });
  nonicons = prev.callPackage ./nonicons { };
}
