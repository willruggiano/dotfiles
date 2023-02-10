{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.dunst;
in {
  options = {
    services.dunst = {
      enable = mkEnableOption "Enable dunst notification daemon";
      package = mkOpt types.package pkgs.dunst;
    };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [dunst libnotify];

    home.dataFile = {
      "dbus-1/services/org.knopwob.dunst.service".source = "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";
    };

    programs.flavours.items.dunst = {
      file = "~/.config/dunst/dunstrc";
      template = "dunst";
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
