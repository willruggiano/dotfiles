self: super:
{
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
    version = "0.5.1";
    src = super.pkgs.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v${version}";
      hash = "sha256-07PrR7KElLJhzS/4Z8lLiWuOehx4npyh4puSAJNqTyw=";
    };
  });
}
