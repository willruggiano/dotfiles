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
      hash = "sha256-GI3TRkD+YPpzkbQb5GfDiUXWDJjZjNgKkQYdxUPaF68=";
    };
  });
  nix-patched = prev.callPackage ./nix { pkgs = prev; };
  nonicons = prev.callPackage ./nonicons { };
}
