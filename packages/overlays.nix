final: prev: {
  autorandr-rs = prev.callPackage ./autorandr-rs {};
  base16-schemes = prev.callPackage ./base16-schemes {};
  base16-templates = prev.callPackage ./base16-templates {};
  circle = prev.callPackage ./circle {};
  dropbox-cli = prev.dropbox-cli.overrideAttrs (_: let
    version = "2022.12.05";
  in {
    inherit version;
    src = prev.fetchurl {
      url = "https://linux.dropbox.com/packages/nautilus-dropbox-${version}.tar.bz2";
      hash = "sha256-TB8TF21mpa2ev5ZOA1vhWWDKHUf0zJ8pdpY/OeXeWSs=";
    };
    patches = [
      (prev.substituteAll {
        src = ./dropbox/fix-cli-paths.patch;
        dropboxd = "${prev.dropbox}/bin/dropbox";
      })
    ];
  });

  docsets = prev.callPackage ./docsets {};
  dummy = prev.runCommand "dummy-0.0.0" {} "mkdir $out";
  firefox-extended = prev.callPackage ./firefox {};
  firenvim = (prev.callPackage ./firenvim {}).package;
  goxlr = prev.callPackage ./goxlr {};
  html2text = prev.callPackage ./html2text {};
  magic-enter-fish = prev.callPackage ./magic-enter.fish {};
  marksman = prev.callPackage ./marksman {};
  neovim-remote = prev.callPackage ./neovim-remote {};
  nonicons = prev.callPackage ./nonicons {};
  nvidia-omniverse = prev.callPackage ./nvidia-omniverse {};
  pass-extension-clip = prev.callPackage ./pass-clip {};
  pass-extension-meta = prev.callPackage ./pass-meta {};
  pre-commit-hooks = prev.callPackage ./pythonPackages/pre-commit-hooks.nix {inherit (prev.python3.pkgs) buildPythonPackage pytestCheckHook pythonOlder ruamel-yaml tomli;};
  spotifyd = prev.spotifyd.override (_: {withMpris = true;});
  src-cli = prev.callPackage ./sourcegraph {};
  xplr = prev.callPackage ./xplr {};
}
