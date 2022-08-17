{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.awesome;
in {
  options.services.awesome = {
    enable = mkEnableOption "AwesomeWM";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
        defaultSession = "none+awesome";
      };
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          # From the nixos manual
          luarocks
          luadbi-mysql
          # Other stuff
          inspect
          lua-awesome
          lua-awesome-volume-control
          lua-awesome-widgets
          lua-dbus-proxy
          lua-lush
        ];
      };
    };

    environment.systemPackages = [pkgs.acpitool];
    user.packages = with pkgs; [dmenu rofi];

    home.configFile = {
      awesome = {
        source = ../../../.config/awesome;
        recursive = true;
      };
    };

    systemd.user.services.reload-awesome-theme = {
      description = "Reload the awesome theme";
      path = with pkgs; [awesome dbus];
      script = ''
        echo 'require("reload")()' | awesome-client
      '';
    };

    systemd.user.timers.reload-awesome-theme = {
      description = "Reload the awesome theme";
      partOf = ["reload-awesome-theme.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
