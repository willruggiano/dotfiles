{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.chromium;
in {
  config = mkIf cfg.enable {
    programs.chromium = {
      extensions = mkBefore [
        # cloaked
        "oppdbdefikkkihgbliidckokhgcmmiga"
        # duck duck go privacy essentials
        "bkdgflcldnnnapblkhphbgpggdiikppg"
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
  };
}
