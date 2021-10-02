{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      browserpass
      ff2mpv
      greasemonkey
      https-everywhere
      metamask
      ublock-origin
      vimium
    ];
    profiles = {
      default = {
        settings = {
          "browser.startup.homepage" = "https://google.com";
        };
      };
    };
  };

  # TODO: This really needs to be under the enablePass gate.
  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  programs.mpv.enable = true;
}
