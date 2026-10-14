{
  flake = {
    overlays.default = _: prev: {
      autorandr-rs = prev.callPackage ./autorandr-rs {};
      jjj = prev.callPackage ./jjj.nix {};
      magic-enter-fish = prev.callPackage ./magic-enter.fish {};
      pass-extension-clip = prev.callPackage ./pass-clip {};
      pass-extension-meta = prev.callPackage ./pass-meta {};
    };
  };
}
