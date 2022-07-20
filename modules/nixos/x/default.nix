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
      layout = "dvp";

      extraLayouts.dvp = {
        description = "Programmer's Dvorak";
        languages = ["eng"];
        symbolsFile = ./xkb/symbols/dvp;
      };

      libinput = {
        enable = mkDefault true;
        touchpad = {
          disableWhileTyping = mkDefault true;
          naturalScrolling = mkDefault true;
          tapping = mkDefault false;
        };
      };

      desktopManager.xterm.enable = false;
      displayManager = {
        autoLogin = {
          enable = mkDefault true;
          user = config.user.name;
        };
      };
    };

    environment.systemPackages = with pkgs; [xclip];

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
