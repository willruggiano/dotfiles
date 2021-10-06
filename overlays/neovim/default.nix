self: super:
{
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    version = "0.5.x";
    src = super.pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "release-0.5";
      hash = "sha256-GI3TRkD+YPpzkbQb5GfDiUXWDJjZjNgKkQYdxUPaF68=";
    };
  });
}
