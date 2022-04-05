{
  fetchurl,
  lib,
  ...
}: let
  version = "master";
in
  fetchurl
  {
    name = "nonicons-${version}";
    url = "https://raw.githubusercontent.com/yamatsum/nonicons/${version}/dist/nonicons.ttf";
    downloadToTemp = true;
    recursiveHash = true;
    hash = "sha256-EqTjrWd61QGZz1xMjKmkQmIiHT5tAOuwXxQAorNbkVI=";

    postFetch = ''
      mkdir -p $out/share/fonts
      install -D $downloadedFile $out/share/fonts/truetype/nonicons.ttf
    '';

    meta = with lib; {
      homepage = "https://github.com/yamatsum/nonicons";
      description = "Nonicons are a set of SVG icons representing programming languages, designing & development tools.";
    };
  }
