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
        profiles = {
          default = {
            extensions = with firefox-addons; [
              duckduckgo-privacy-essentials
              firenvim
              greasemonkey
              # https-everywhere
              metamask
              multi-account-containers
              sourcegraph
              ublock-origin
              vimium
              (firefox-addons.buildFirefoxXpiAddon rec {
                pname = "aws-sso-containers";
                version = "1.0";
                addonId = "pyro2927@aws-sso-containers";
                url = "https://github.com/pyro2927/AWS_SSO_Containers/releases/download/v${version}/aws_sso_container.xpi";
                sha256 = "sha256-+mfJAhlGxuMD7FGqpnI4UmlNbN9lsqUmN54b7QhLZMw=";
                meta = {
                  homepage = "https://github.com/pyro2927/AWS_SSO_Containers";
                  description = "Firefox extension to route AWS SSO logins into unique containers.";
                };
              })
            ];
            settings = {
              "app.update.auto" = false;
              "browser.startup.homepage" = "https://github.com";
            };
          };
        };
      };
    }
    (mkIf config.programs.mpv.enable {
      programs.firefox.profiles.default.extensions = [firefox-addons.ff2mpv];
    })
    (mkIf config.programs.password-store.enable {
      programs.firefox.profiles.default.extensions = [firefox-addons.browserpass];
      programs.browserpass = {
        enable = true;
        browsers = ["firefox"];
      };
    })
  ]);
}
