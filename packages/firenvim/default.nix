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
      version = "0.2.13";
      src = fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "v${version}";
        hash = "sha256-86Gr+95yunuNZGn/+XLPg1ws6z4C2VOMKt81a6+sxnI=";
      };
      buildInputs = [pkgconfig glib vips];

      passthru.plugin = stdenv.mkDerivation {
        pname = "firenvim-plugin";
        inherit version src;
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
