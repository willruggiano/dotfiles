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
    launchd.user.agents = mapAttrs' (name: cfg:
      nameValuePair "apply-${name}-theme" (mkIf cfg.enable {
        path = [pkgs.colorctl];
        script = "colorctl build ${optionalString (cfg.reload-command != null) "--reload --reload-command ${cfg.reload-command}"} ${name}";
        serviceConfig = {
          KeepAlive = false;
          StartCalendarInterval = [
            {
              Minute = 0;
            }
          ];
        };
      }))
    cfg.settings;
  };
}
