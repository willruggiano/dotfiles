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
          lua-lush
        ];
      };
    };

    home.configFile = {
      awesome = {
        source = ../../../.config/awesome;
        recursive = true;
      };
    };

    systemd.user.services.restart-awesome = {
      description = "Restart awesomewm";
      path = with pkgs; [awesome dbus];
      script = ''
        echo 'awesome.restart()' | awesome-client
      '';
    };

    systemd.user.timers.restart-awesome = {
      description = "Restart awesomewm to apply theme changes";
      partOf = ["restart-awesome.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
