{
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  name = "cppman";

  src = ./.;

  buildPhase = ''
    tar -xf ./cppreference.com.tar.gz
  '';

  installPhase = ''
    mkdir -p $out/share/man/man3
    cp cppreference.com/*.gz $out/share/man/man3
  '';
}
