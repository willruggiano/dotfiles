{pkgs, ...}: {
  config = {
    systemd.user.services.reload-lazygit-theme = {
      description = "Reload lazygit theme";
      path = with pkgs; [colorctl];
      script = "colorctl build lazygit";
    };

    systemd.user.timers.reload-lazygit-theme = {
      description = "Reload lazygit theme";
      partOf = ["reload-lazygit-theme.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
