{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    systemd.user.services.apply-bat-theme = {
      description = "Re-apply bat theme";
      path = with pkgs; [bat colorctl];
      script = ''
        colorctl build bat && bat cache --clear && bat cache --build
      '';
    };

    systemd.user.timers.apply-bat-theme = {
      description = "Re-apply bat theme";
      partOf = ["apply-bat-theme.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
