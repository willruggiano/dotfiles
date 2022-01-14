{ pkgs, ... }:

let
  python = pkgs.python39.pkgs;
in
python.buildPythonApplication rec {
  pname = "cppman";
  version = "0.5.3";

  src = pkgs.fetchFromGitHub {
    owner = "aitjcize";
    repo = "cppman";
    rev = "4d13afba02d8822d798b0769178e481edadfbcca";
    hash = "sha256-qRmfKtGyU/nBl5Lwr7KdaAdjJt06GClcblrBb9mQbgg=";
  };

  doCheck = false;

  propagatedBuildInputs = with python; [
    beautifulsoup4
    html5lib
  ];
}
