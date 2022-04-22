{
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "rope";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "python-rope";
    repo = "rope";
    rev = version;
    hash = "sha256-fA2p+W6DVb0RQhO2uZs/kK67fFlc09odHnU0lWqTxrE=";
  };

  checkInputs = [pytestCheckHook];

  disabledTestPaths = [
    # AttributeError: Can't pickle local object 'DOATest.try_CVE_2014_3539_exploit.<locals>.attacker'
    "ropetest/doatest.py"
  ];
}
