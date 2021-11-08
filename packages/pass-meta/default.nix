{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pass-meta";
  version = "master";

  src = fetchFromGitHub {
    owner = "rjekker";
    repo = "pass-extension-meta";
    rev = "${version}";
    hash = "sha256-O/YatXOA4EiGnGkemmGd6pVCNVwrtDeLoDq9PRSlGY4=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "@install -v -m 0755 src/metamenu \"\$(BINDIR)/metamenu\"" "@install -v -D -m 0755 src/metamenu \"\$(BINDIR)/metamenu\""
  '';

  dontBuild = true;

  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/share/bash-completion/completions"
    "BINDIR=$(out)/bin"
  ];

  meta = with lib; {
    description = "password-store extension to retrieve meta-data properties from password files";
    homepage = "https://github.com/rjekker/pass-extension-meta";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
