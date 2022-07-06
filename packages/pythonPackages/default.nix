final: prev: {
  pre-commit-hooks = prev.pre-commit-hooks.override (_: {
    propagatedBuildInputs = with prev; [ruamel-yaml tomli];
  });
  pylsp-rope = prev.callPackage ./python-lsp-server/pylsp-rope.nix {
    inherit (prev) buildPythonPackage pythonOlder pytestCheckHook mock;
    inherit (final) python-lsp-server rope;
  };
  python-lsp-server = prev.callPackage ./python-lsp-server {inherit (prev) python-lsp-server fetchPypi setuptools-scm;};
  rope = prev.callPackage ./python-lsp-server/rope.nix {inherit (prev) buildPythonPackage pytestCheckHook;};
}
