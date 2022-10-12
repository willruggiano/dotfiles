{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.colorctl;
in {
  options.programs.colorctl = {
    enable = mkEnableOption "Enable colorctl";
    settings = mkOption {
      description = "Attribute set of application specific configuration";
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          reload = mkEnableOption "Enable reload for application";
          reload-command = mkOption {
            type = types.str;
            default = "";
            description = "Command to run to reload application";
          };
        };
      });
    };
  };

  config = let
    settings-format = pkgs.formats.toml {};
  in
    mkIf cfg.enable (
      mkMerge [
        {
          user.packages = with pkgs; [colorctl];

          home.configFile = {
            "colorctl/config.toml".source = settings-format.generate "colorctl-config.toml" cfg.settings;
          };
        }
        (mkIf pkgs.stdenv.isLinux {
          systemd.user.services =
            mapAttrs' (
              name: cfg:
                nameValuePair "apply-${name}-theme" (mkIf cfg.reload {
                  description = "Re-apply ${name} theme";
                  path = with pkgs; [colorctl];
                  script = "colorctl build ${optionalString (cfg.reload-command != "") "--reload"} ${name}";
                  wantedBy = ["sleep.target"];
                })
            )
            cfg.settings;

          systemd.user.timers =
            mapAttrs' (
              name: cfg:
                nameValuePair "apply-${name}-theme" (mkIf cfg.reload {
                  description = "Re-apply ${name} theme";
                  partOf = ["apply-${name}-theme.service"];
                  wantedBy = ["timers.target"];
                  timerConfig.OnCalendar = "hourly";
                })
            )
            cfg.settings;
        })
      ]
    );
}
