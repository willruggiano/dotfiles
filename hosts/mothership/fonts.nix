{ lib, fetchurl, ... }:

let
  pname = "nonicons";
  version = "master";
in
fetchurl {
  name = "${pname}-${version}";
  url = "https://raw.githubusercontent.com/yamatsum/nonicons/master/dist/nonicons.ttf";
  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/${pname}.ttf
  '';
  hash = "sha256-6c2nUGmPA4PCQRncwVtXpGS4qNz5c6sPi6nnBmRby64=";
}
