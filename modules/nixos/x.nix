{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.xserver;
in {
  config = mkIf cfg.enable {
    services.xserver = {
      layout = "us";
      xkbOptions = "ctrl:nocaps";

      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          naturalScrolling = true;
          tapping = false;
        };
      };

      desktopManager.xterm.enable = false;
      displayManager = {
        autoLogin = {
          enable = true;
          user = config.user.name;
        };
      };
    };

    systemd.user.services.xbanish = {
      description = "banish the mouse cursor when typing";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = "${pkgs.xbanish}/bin/xbanish";
        Restart = "always";
      };
    };
  };
}
