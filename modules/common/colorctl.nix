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
      type = types.attrsOf (
        types.submodule (name: {
          options = {
            enable = mkEnableOption "Enable colorctl for ${name}";
            reload-command = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Command to run to reload ${name}";
            };
          };
        })
      );
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        user.packages = with pkgs; [colorctl];
      }
      (mkIf pkgs.stdenv.isLinux {
        systemd.user.services =
          mapAttrs' (
            name: cfg:
              nameValuePair "apply-${name}-theme" (mkIf cfg.enable {
                description = "Re-apply ${name} theme";
                path = with pkgs; [colorctl];
                script = "colorctl build ${optionalString (cfg.reload-command != null) "--reload --reload-command ${cfg.reload-command}"} ${name}";
                wantedBy = ["sleep.target"];
              })
          )
          cfg.settings;

        systemd.user.timers =
          mapAttrs' (
            name: cfg:
              nameValuePair "apply-${name}-theme" (mkIf cfg.enable {
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
