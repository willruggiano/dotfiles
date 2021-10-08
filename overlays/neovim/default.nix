self: super:
{
  neovim-latest = super.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    version = "0.5.x";
    src = super.pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "release-0.5";
      hash = "sha256-GI3TRkD+YPpzkbQb5GfDiUXWDJjZjNgKkQYdxUPaF68=";
    };
  });
  neovim-master = self.neovim;
}
