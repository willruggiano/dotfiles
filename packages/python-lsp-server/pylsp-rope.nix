{
  lib,
  pkgs,
  fetchFromGitHub,
  ...
}: let
  inherit (pkgs.python39Packages) buildPythonPackage pythonOlder pytestCheckHook mock rope python-lsp-server;
in
  buildPythonPackage rec {
    pname = "pylsp-rope";
    version = "0.1.8";
    disabled = pythonOlder "3.6";

    src = fetchFromGitHub {
      owner = "python-rope";
      repo = "pylsp-rope";
      rev = version;
      hash = "sha256-hrhn86OHZ+8rlqh020URQHtrYQ0BtgbGxw5D28WBYks=";
    };

    checkInputs = [pytestCheckHook mock];

    propagatedBuildInputs = [rope python-lsp-server];

    pythonImportsCheck = ["pylsp_rope"];
  }
