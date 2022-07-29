{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "goxlr";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "GoXLR-on-Linux";
    repo = "goxlr-utility";
    rev = "v${version}";
    hash = "sha256-Qg8JGy+51+4YZBzbjt3cVMYd+cX8/TFnXkL2OHlCKqQ=";
  };

  cargoSha256 = "sha256-mF0kn82TxHe5Xrt+DUGqmJU3gVnQuHjEMQAIjfoU3Rk=";

  passthru.goxlr-udev-rules = stdenv.mkDerivation {
    name = "goxlr-udev-rules";

    dontUnpack = true;
    installPhase = ''
      install -Dm 644 "${src}/50-goxlr.rules" $out/lib/udev/rules.d/50-goxlr.rules
    '';
  };

  meta = with lib; {
    description = "A CLI for configuration a GoXLR on Linux";
    homepage = "https://github.com/GoXLR-on-Linux/goxlr-utility";
    license = licenses.mit;
  };
}
