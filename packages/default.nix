{self, ...}: {
  perSystem = {
    system,
    inputs',
    ...
  }: {
    packages.himalaya = inputs'.himalaya.packages.default.override {
      buildFeatures = ["keyring" "notmuch" "oauth2"];
    };
  };

  flake = {
    overlays.default = final: prev: {
      inherit (self.packages.${prev.system}) himalaya;
      autorandr-rs = prev.callPackage ./autorandr-rs {};
      base16-templates = prev.callPackage ./base16-templates {};
      magic-enter-fish = prev.callPackage ./magic-enter.fish {};
      nonicons = prev.callPackage ./nonicons {};
      pass-extension-clip = prev.callPackage ./pass-clip {};
      pass-extension-meta = prev.callPackage ./pass-meta {};
      tunnel9 = prev.callPackage ./tunnel9 {};
    };
  };
}
