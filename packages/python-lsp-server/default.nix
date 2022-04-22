{
  python-lsp-server,
  fetchPypi,
  setuptools-scm,
}:
python-lsp-server.overrideAttrs (prev: rec {
  version = "1.4.1";
  src = fetchPypi {
    inherit (prev) pname;
    inherit version;
    hash = "sha256-vn+DKYr58JUak5csr8nbBP189cBfIIElFSdfC6cONC8=";
  };
  propagatedBuildInputs = prev.propagatedBuildInputs ++ [setuptools-scm];
})
