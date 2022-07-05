{
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "rope";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "python-rope";
    repo = "rope";
    rev = version;
    hash = "sha256-BwODbTJuiaV3h0HnNmqqs90WDzbRH6BHy8xArVwujfM=";
  };

  checkInputs = [pytestCheckHook];

  disabledTestPaths = [
    # AttributeError: Can't pickle local object 'DOATest.try_CVE_2014_3539_exploit.<locals>.attacker'
    "ropetest/doatest.py"
    "ropetest/contrib/autoimporttest.py"
    "ropetest/contrib/autoimport/utilstest.py"
  ];
}
