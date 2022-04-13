{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.firefox;
  inherit (pkgs.nur.repos.rycee) firefox-addons;
in {
  config = mkIf cfg.enable (mkMerge [
    {
      programs.firefox = {
        extensions = with firefox-addons; [
          duckduckgo-privacy-essentials
          greasemonkey
          https-everywhere
          metamask
          ublock-origin
          vimium
        ];
        profiles = {
          default = {
            settings = {
              "app.update.auto" = false;
              "browser.startup.homepage" = "https://duckduckgo.com";
            };
          };
        };
      };

      home.packages = with pkgs; [
        (writeShellApplication {
          name = "firefox-private";
          runtimeInputs = [cfg.package];
          text = ''
            firefox --private-window
          '';
        })
      ];
    }
    (mkIf config.programs.mpv.enable {
      programs.firefox.extensions = [firefox-addons.ff2mpv];
    })
    (mkIf config.programs.password-store.enable {
      programs.firefox.extensions = [firefox-addons.browserpass];
      programs.browserpass = {
        enable = true;
        browsers = ["firefox"];
      };
    })
  ]);
}
