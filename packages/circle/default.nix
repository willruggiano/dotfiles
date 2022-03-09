{ stdenv, fetchzip, autoPatchelfHook, elfutils, libuuid, zlib }:

stdenv.mkDerivation {
  pname = "circle";
  version = "161";

  src = fetchzip {
    url = "https://www.circle-lang.org/linux/build_161.tgz";
    hash = "sha256-xTc7ocsbgwdTAjD4qoCGbsfBiVP2+DeKHVRJ9h0SmzQ=";
    stripRoot = false;
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ elfutils libuuid zlib ];
  propagatedBuildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    install -m755 -D circle $out/bin/circle
  '';
}
