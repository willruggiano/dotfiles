{
  config,
  pkgs,
}: let
  kitty = "${pkgs.kitty}/bin/kitty";
  light = "${pkgs.light}/bin/light";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
in
  builtins.toJSON {
    # Global
    layer = "bottom";
    position = "bottom";
    height = 24;
    modules-left = [
      "sway/workspaces"
      "sway/mode"
    ];
    modules-center = [
      "sway/window"
    ];
    modules-right = [
      "tray"
      "network"
      "cpu"
      "memory"
      "pulseaudio"
      "backlight"
      "battery"
      "idle_inhibitor"
      "clock"
      # "sway/language"
    ];

    # Modules
    backlight = {
      format = "{percent}%";
      interval = 2;
      on-scroll-up = "${light} -A 2";
      on-scroll-down = "${light} -U 2";
    };

    battery = {
      interval = 10;
      states = {
        warning = 25;
        critical = 15;
      };
      # Connected to AC
      format = "{capacity}%";
      # Not connected to AC
      format-discharging = "{capacity}%";
      tooltip = true;
    };

    clock = {
      interval = 60;
      format = "{:%e %b %Y %H:%M}";
      locale = "${config.i18n.defaultLocale}";
      timezone = "${config.time.timeZone}";
    };

    cpu = {
      interval = 3;
      format = "{usage}% ~{load}";
      states = {
        warning = 70;
        critical = 90;
      };
    };

    idle_inhibitor = {
      format = "({status})";
      tooltip = false;
    };

    memory = {
      interval = 3;
      format = "{}%";
      states = {
        warning = 70;
        critical = 90;
      };
    };

    network = {
      interval = 3;
      format-wifi = "{essid}";
      format-ethernet = "{ifname}: {ipaddr}/{cidr}";
      format-disconnected = "";
      tooltip-format = "{ifname}: {ipaddr} (signal: {signalStrength}%)";
    };

    pulseaudio = {
      scroll-step = 2;
      format = "{volume}%";
      format-muted = "Muted";
      on-click = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
      tooltip = true;
    };

    "sway/language" = {
      format = "[{short}]";
    };

    "sway/mode" = {
      format = "Mode: {}";
      tooltip = false;
    };
    "sway/window" = {
      format = "{}";
      max-length = 120;
    };
    "sway/workspaces" = {
      all-outputs = false;
      disable-scroll = true;
      format = "{name}";
    };

    temperature = {
      critical-threshold = 75;
      interval = 3;
      format = "{temperatureC}°C";
      tooltip = true;
    };

    tray = {
      icon-size = 21;
      spacing = 10;
    };
  }
