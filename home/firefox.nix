{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      browserpass
      greasemonkey
      https-everywhere
      ublock-origin
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
}
