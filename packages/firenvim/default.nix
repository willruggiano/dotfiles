{
  pkgs,
  system,
  nodejs,
  fetchFromGitHub,
  pkgconfig,
  glib,
  vips,
  stdenv,
}: let
  nodePackages = import ./firenvim.nix {inherit pkgs system nodejs;};
in
  nodePackages
  // {
    package = nodePackages.package.override rec {
      src = fetchFromGitHub {
        owner = "willruggiano";
        repo = "firenvim";
        rev = "master";
        hash = "sha256-7gFV0iPU/y2PMUlGnzGiRe7ofnaodZdFG6yeBr5S2gQ=";
      };
      buildInputs = [pkgconfig glib vips];

      passthru.plugin = stdenv.mkDerivation {
        pname = "firenvim-plugin";
        version = "0.2.12";
        inherit src;
        dontBuild = true;
        installPhase = ''
          mkdir $out
          ln -s $src/autoload $out/
          ln -s $src/lua $out/
          ln -s $src/plugin $out/
        '';
      };
    };
  }
