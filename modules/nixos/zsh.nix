{pkgs, ...}: {
  config = {
    systemd.user.services.reload-vivid-theme = {
      description = "Reload vivid theme";
      path = with pkgs; [colorctl];
      script = "colorctl build vivid";
    };

    systemd.user.timers.reload-vivid-theme = {
      description = "Reload vivid theme";
      partOf = ["reload-vivid-theme.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
