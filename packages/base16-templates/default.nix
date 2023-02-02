{
  lib,
  stdenv,
  buildEnv,
}:
with lib; let
  sources = import ./nix/sources.nix {};

  sources-drvs = mapAttrsToList (name: src:
    stdenv.mkDerivation {
      inherit name src;

      dontConfigure = true;
      dontBuild = true;
      dontFixup = true;

      installPhase = let
        pname = strings.removePrefix "base16-" name;
      in ''
        mkdir -p $out/templates/${pname}
        cp -R . $out/templates/${pname}
      '';
    })
  sources;
in
  buildEnv {
    name = "base16-templates";
    paths = sources-drvs;
  }
