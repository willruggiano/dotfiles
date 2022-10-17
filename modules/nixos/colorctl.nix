{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.colorctl;
in {
  config = mkIf cfg.enable {
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
  };
}
