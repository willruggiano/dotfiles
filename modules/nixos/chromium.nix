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
          # cloaked
          "oppdbdefikkkihgbliidckokhgcmmiga"
          # darkreader
          "eimadpbcbfnmbkopoojfekhnkhdbieeh"
          # duck duck go privacy essentials
          "bkdgflcldnnnapblkhphbgpggdiikppg"
          # lesspass - pretty cool idea but not especially practical :/
          "lcmbpoclaodbgkbjafnkbbinogcbnjih"
          # metamask
          "nkbihfbeogaeaoehlefnkodbefgpgknn"
          # react dev tools
          "fmkadmapgofadopljbjfkapdkoienihi"
          # relay dev tools
          "ncedobpgnmkhcmnnkcimnobpfepidadl"
          # ublock-origin
          "cjpalhdlnbpafiamejdnhcphjbkeiagm"
        ];

        extraOpts = {
          AudioCaptureAllowed = true;
          BrowserSignin = 0;
          # https://github.com/danth/stylix/blob/master/modules/chromium/nixos.nix
          BrowserThemeColor = config.lib.stylix.colors.withHashtag.base00;
          # Do not allow any site to display desktop notifications
          DefaultNotificationsSetting = 2;
          # except for:
          NotificationsAllowedForUrls = [
            "https://meet.google.com"
            "https://app.slack.com/client"
          ];
          HttpsOnlyMode = "force_enabled";
          PasswordManagerEnabled = false;
          PaymentMethodQueryEnabled = false;
          ScreenCaptureAllowed = true;
          ShowHomeButton = true;
          SpellcheckEnabled = true;
          SpellcheckLanguage = ["en-US"];
          SyncDisabled = false;
          VideoCaptureAllowed = true;
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
