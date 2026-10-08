{
  flake = {
    overlays.default = _: prev: {
      autorandr-rs = prev.callPackage ./autorandr-rs {};
      magic-enter-fish = prev.callPackage ./magic-enter.fish {};
      pass-extension-clip = prev.callPackage ./pass-clip {};
      pass-extension-meta = prev.callPackage ./pass-meta {};
    };
  };
}
