{
  inputs,
  self,
  ...
}: {
  perSystem = {system, ...}: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
    };
  in {
    _module.args.pkgs = pkgs;

    # for python lsp auto-complete
    devenv.shells.default.packages = pkgs.docsets.docsets."Postgresql.docset".buildInputs;
  };

  flake = {
    overlays.default = final: prev: {
      autorandr-rs = prev.callPackage ./autorandr-rs {};
      base16-templates = prev.callPackage ./base16-templates {};
      brave-browser = inputs.nixpkgs-latest.legacyPackages.${prev.system}.brave;
      docsets = prev.callPackage ./docsets {};
      magic-enter-fish = prev.callPackage ./magic-enter.fish {};
      nonicons = prev.callPackage ./nonicons {};
      pass-extension-clip = prev.callPackage ./pass-clip {};
      pass-extension-meta = prev.callPackage ./pass-meta {};
    };
  };
}
