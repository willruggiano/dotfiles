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
    find ./cppreference.com -name "*.gz" -type f -exec cp {} $out/share/man/man3 \;
  '';
}
