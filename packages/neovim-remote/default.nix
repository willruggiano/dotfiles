{
  fetchFromGitHub,
  python3,
  neovim,
}:
with python3.pkgs;
  buildPythonApplication rec {
    pname = "neovim-remote";
    version = "2.5.1";

    src = fetchFromGitHub {
      owner = "mhinz";
      repo = "neovim-remote";
      rev = "v${version}";
      hash = "sha256-uO5KezbUQGj3rNpuw2SJOzcP86DZqX7DJFz3BxEnf1E=";
    };

    propagatedBuildInputs = [pynvim psutil setuptools];

    doCheck = false;
  }
