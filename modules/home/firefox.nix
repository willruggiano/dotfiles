{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.firefox;
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
in
{
  config = (mkMerge [
    (mkIf cfg.enable {
      programs.firefox = {
        extensions = with firefox-addons; [
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
    })
    (mkIf config.programs.mpv.enable {
      programs.firefox.extensions = [ firefox-addons.ff2mpv ];
    })
    (mkIf config.programs.password-store.enable {
      programs.firefox.extensions = [ firefox-addons.browserpass ];
      programs.browserpass = {
        enable = true;
        browsers = [ "firefox" ];
      };
    })
  ]);
}
