{
  inputs,
  self,
  ...
}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
    };
  };

  flake = {
    overlays.default = final: prev: {
      autorandr-rs = prev.callPackage ./autorandr-rs {};
      base16-templates = prev.callPackage ./base16-templates {};
      docsets = prev.callPackage ./docsets {};
      magic-enter-fish = prev.callPackage ./magic-enter.fish {};
      nonicons = prev.callPackage ./nonicons {};
      pass-extension-clip = prev.callPackage ./pass-clip {};
      pass-extension-meta = prev.callPackage ./pass-meta {};
    };
  };
}
