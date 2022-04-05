{
  pkgs,
  lib,
  fetchFromGitHub,
  ...
}:
with pkgs;
  stdenv.mkDerivation rec {
    pname = "keyd";
    version = "2.1.0-beta";

    src = fetchFromGitHub {
      owner = "rvaiya";
      repo = "keyd";
      rev = "57f9aa5804c566ad877cba987beec2bcd214d612";
      hash = "sha256-CnHr7acCboc9XH7GQT5V8yPSUtoLz+8+mtii4ThvNwQ=";
    };

    buildInputs = [git udev];

    buildPhase = ''
      make LOCK_FILE=/tmp/keyd.lock LOG_FILE=/tmp/keyd.log
    '';

    installPhase = ''
      make install DESTDIR=$out PREFIX=
      rm -rf $out/lib
    '';

    meta = {
      description = "A key remapping daemon for linux.";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  }
