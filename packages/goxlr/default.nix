{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "goxlr";
  version = "main";
  src = fetchFromGitHub {
    owner = "GoXLR-on-Linux";
    repo = "goxlr-utility";
    rev = "7ed2cd49f324d4e01c1bba85b87ef64df541b4f3";
    hash = "sha256-Qg8JGy+51+4YZBzbjt3cVMYd+cX8/TFnXkL2OHlCKqQ=";
  };

  cargoSha256 = "sha256-PmzGE4Aod4VavH68YFILk/LSW1T3hem/xWnmrqJxnhQ=";

  passthru.goxlr-udev-rules = stdenv.mkDerivation {
    name = "goxlr-udev-rules";

    dontUnpack = true;

    installPhase = ''
      install -Dm 644 "${./50-goxlr.rules}" $out/lib/udev/rules.d/50-goxlr.rules
    '';
  };

  meta = with lib; {
    description = "A CLI for configuration a GoXLR on Linux";
    homepage = "https://github.com/GoXLR-on-Linux/goxlr-utility";
    license = licenses.mit;
  };
}
