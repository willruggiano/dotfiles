{
  pkgs,
  system,
  nodejs,
  fetchFromGitHub,
  pkgconfig,
  glib,
  vips,
}: let
  nodePackages = import ./firenvim.nix {inherit pkgs system nodejs;};
in
  nodePackages
  // {
    package = nodePackages.package.override {
      src = fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "0.2.12";
        hash = "sha256-4HOz1SjxJQTenUGV35Y8kYQlLXHqMtb1BDRBioEf4WM=";
      };
      buildInputs = [pkgconfig glib vips];
    };
  }
