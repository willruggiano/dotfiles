{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:
rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-L9eJd1ivFhAmjKVm+HFq9fNiA/UA/x2akEfa1CrUSBo=";
  };

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  cargoSha256 = "sha256-niH8gj49Wr20Lpa6UAczQ+YHgJlkvZYKJGFH6Spk9Ho=";
}
