{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.kitty;
in {
  config = mkIf cfg.enable {
    user.packages = [pkgs.kitty];

    systemd.user.services.apply-kitty-theme = {
      description = "Re-apply kitty theme";
      path = with pkgs; [kitty colorctl procps];
      script = ''
        colorctl ${./.}/shipwright.lua && {
          for pid in $(pgrep kitty-wrapped); do
            kitty @ --to unix:@kitty-$pid set-colors --all ~/.config/kitty/theme.conf
          done
        }
      '';
    };

    systemd.user.timers.apply-kitty-theme = {
      description = "Re-apply kitty theme";
      partOf = ["apply-kitty-theme.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
