{pkgs, ...}:
# TODO: It's a bummer that only ESR is supported for addons :(
pkgs.wrapFirefox pkgs.firefox-unwrapped {
  nixExtensions = [
    (pkgs.fetchFirefoxAddon {
      name = "ublock";
      url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
      hash = "sha256-2e73AbmYZlZXCP5ptYVcFjQYdjDp4iPoEPEOSCVF5sA=";
    })
  ];
}
