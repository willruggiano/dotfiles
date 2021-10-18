{ pkgs, ... }:

let
  python = pkgs.python39.pkgs;
in
python.buildPythonApplication rec {
  pname = "cppman";
  version = "0.5.3";

  src = python.fetchPypi {
    inherit pname version;
    hash = "sha256-J7jO5+mQVXcNglH5ady5xJcjQvkiUONBv54QuWeKkUA=";
  };

  doCheck = false;

  propagatedBuildInputs = with python; [
    beautifulsoup4
    html5lib
  ];
}
