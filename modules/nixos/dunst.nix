{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.dunst;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package pkgs.libnotify];

    home.dataFile = {
      "dbus-1/services/org.knopwob.dunst.service".source = "${cfg.package}/share/dbus-1/services/org.knopwob.dunst.service";
    };

    systemd.user.services.dunst = {
      description = "dunst, a notification daemon";
      after = ["graphical-session-pre.target"];
      partOf = ["graphical-session.target"];
      serviceConfig = {
        BusName = "org.freedesktop.Notifications";
        Environment = "WAYLAND_DISPLAY=wayland-1";
        ExecStart = "${cfg.package}/bin/dunst";
        Restart = "always";
        Type = "dbus";
      };
    };
  };
}
