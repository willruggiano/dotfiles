{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.chromium;
in {
  config = mkIf cfg.enable (mkMerge [
    {
      programs.chromium = {
        extensions = mkBefore [
          # duck duck go privacy essentials
          "bkdgflcldnnnapblkhphbgpggdiikppg"
          # firenvim
          "egpjdkipkomnmjhjmdamaniclmdlobbo"
          # metamask
          "nkbihfbeogaeaoehlefnkodbefgpgknn"
          # sourcegraph
          "dgjhfomjieaadpoljlnidmbgkdffpack"
          # ublock-origin
          "cjpalhdlnbpafiamejdnhcphjbkeiagm"
          # vimium
          "dbepggeogbaibhgnhhndojpepiihcmeb"
        ];

        homepageLocation = "https://github.com";

        extraOpts = {
          BrowserSignin = 0;
          SyncDisabled = false;
          HttpsOnly = "force_enabled";
          PasswordManagerEnabled = false;
          PaymentMethodQueryEnabled = false;
          SpellcheckEnabled = true;
          SpellcheckLanguage = ["en-US"];
        };
      };
    }
    (mkIf config.programs.browserpass.enable {
      programs.chromium.extensions = ["naepdomgkenhinolocfifgehidddafch"];
      environment.etc = {
        "brave/native-messaging-hosts/com.github.browserpass.native.json".source = "${pkgs.browserpass}/lib/browserpass/policies/chromium/com.github.browserpass.native.json";
      };
    })
  ]);
}
