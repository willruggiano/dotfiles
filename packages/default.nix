{ inputs }:

final: prev: {
  cppman = prev.callPackage ./cppman { };
  firefox-extended = prev.callPackage ./firefox { };
  neovim-latest = prev.neovim-unwrapped.overrideAttrs (_: rec {
    version = "master";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = version;
      hash = "sha256-WNnV0oJ1xTw2JzbEobXhUzkSMqlSmLEjLQCkY8AbcK8=";
    };
  });
  nonicons = prev.callPackage ./nonicons { };
  pass-extension-meta = prev.callPackage ./pass-meta { };
}
