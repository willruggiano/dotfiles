{
  fetchurl,
  lib,
  ...
}: let
  rev = "0d5828e295fa4863a6d318a127d3767623563eb3";
in
  fetchurl
  {
    name = "nonicons";
    url = "https://raw.githubusercontent.com/yamatsum/nonicons/${rev}/dist/nonicons.ttf";
    downloadToTemp = true;
    recursiveHash = true;
    hash = "sha256-stc/o8b9Eudh4vTi1z/9rvFV/su2AF1Aapb09hstWB4=";

    postFetch = ''
      mkdir -p $out/share/fonts
      install -D $downloadedFile $out/share/fonts/truetype/nonicons.ttf
    '';

    meta = with lib; {
      homepage = "https://github.com/yamatsum/nonicons";
      description = "Nonicons are a set of SVG icons representing programming languages, designing & development tools.";
    };
  }
