{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.keyd;
  settings_format = pkgs.formats.ini {
    mkKeyValue = generators.mkKeyValueDefault {} " = ";
  };
in {
  options.services.keyd = with types; {
    enable = mkEnableOption "Enable keyd";
    invertShiftKey = mkEnableOption "Invert shift key without breaking modifier behavior";
    altGrNav = mkEnableOption "AltGr + h/j/k/l => left/down/up/right";
    config = mkOption {
      description = "Default keyd configuration";
      type = str;
    };
    # layers = mkOption {
    #   description = "Attribute set of settings to add to default.conf";
    #   default = {};
    #   type = attrsOf (
    #     submodule {
    #       freeformType = attrsOf str;
    #     }
    #   );
    # };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [pkgs.keyd];
      user.extraGroups = ["keyd"];

      systemd.services.keyd = {
        enable = true;
        requires = ["local-fs.target"];
        after = ["local-fs.target"];
        wantedBy = ["default.target"];
        description = "keyd remapping daemon";
        serviceConfig = {
          ExecStart = "${pkgs.keyd}/bin/keyd";
          Restart = "always";
        };
      };

      environment.etc = {
        "keyd/default.conf".text = concatStringsSep "\n" ([cfg.config]
        ++ optional cfg.altGrNav "include nav"
        ++ optional cfg.invertShiftKey "include shift"
        # ++ ["include user"]
        # HACK: Without this, for some reason, keyd errors on startup with: 'failed to parse /etc/keyd/default.conf'
        ++ [""]);

        # "keyd/user".source = settings_format.generate "user.conf" cfg.layers;
      };
    })
    (mkIf cfg.altGrNav {
      environment.etc = {
        "keyd/nav".source = let
          navConf = {
            main = {
              rightalt = "layer(nav)";
            };

            nav = {
              h = "left";
              j = "down";
              k = "up";
              l = "right";
            };
          };
        in
          settings_format.generate "nav.conf" navConf;
      };
    })
    (mkIf cfg.invertShiftKey {
      environment.etc = {
        "keyd/shift".source = let
          shiftConf = {
            main = {
              leftalt = "layer(display)";

              "1" = "!";
              "2" = "@";
              "3" = "#";
              "4" = "$";
              "5" = "%";
              "6" = "^";
              "7" = "&";
              "8" = "*";
              "9" = "(";
              "0" = ")";
            };

            # For window managers like awesomewm which use Alt-# to switch workspaces
            # Note that this inherits from the 'Alt' modified layer
            "display:A" = {
              shift = "layer(display_shift)";

              "1" = "A-1";
              "2" = "A-2";
              "3" = "A-3";
              "4" = "A-4";
              "5" = "A-5";
              "6" = "A-6";
              "7" = "A-7";
              "8" = "A-8";
              "9" = "A-9";
              "0" = "A-0";
            };

            "display_shift:S" = {
              "1" = "A-S-1";
              "2" = "A-S-2";
              "3" = "A-S-3";
              "4" = "A-S-4";
              "5" = "A-S-5";
              "6" = "A-S-6";
              "7" = "A-S-7";
              "8" = "A-S-8";
              "9" = "A-S-9";
              "0" = "A-S-0";
            };

            shift = {
              "1" = 1;
              "2" = 2;
              "3" = 3;
              "4" = 4;
              "5" = 5;
              "6" = 6;
              "7" = 7;
              "8" = 8;
              "9" = 9;
              "0" = 0;
            };
          };
        in
          settings_format.generate "shift.conf" shiftConf;
      };
    })
  ];
}
