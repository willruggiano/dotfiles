{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    programs.colorctl.settings = {
      bat = {
        reload = true;
        reload-command = let
          cmd = pkgs.writeShellApplication {
            name = "reload-bat-theme";
            runtimeInputs = with pkgs; [bat];
            text = ''
              bat cache --clear && bat cache --build
            '';
          };
        in "${cmd}/bin/reload-bat-theme";
      };
    };

    systemd.user.services.reload-bat-theme = {
      description = "Reload bat theme";
      path = with pkgs; [colorctl];
      script = ''
        colorctl build --reload bat
      '';
    };

    systemd.user.timers.reload-bat-theme = {
      description = "Reload bat theme";
      partOf = ["reload-bat-theme.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
