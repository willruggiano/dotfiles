{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.shpool;
  toml = pkgs.formats.toml {};
in {
  options.programs.shpool = {
    enable = lib.mkEnableOption "shpool persistent shell sessions";
    package = lib.mkPackageOption pkgs "shpool" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    systemd.user.services.shpool = {
      description = "Shpool - Shell Session Pool";

      unitConfig.Requires = "shpool.socket";

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} daemon";
        KillMode = "mixed";
        TimeoutStopSec = "2s";
        SendSIGHUP = true;
      };
    };

    systemd.user.sockets.shpool = {
      description = "Shpool Shell Session Pooler";

      socketConfig = {
        ListenStream = "%t/shpool/shpool.socket";
        SocketMode = "0600";
      };

      wantedBy = ["sockets.target"];
    };

    home.configFile."shpool/config.toml".source = toml.generate "config.toml" {
      default_dir = ".";
      forward_env = [
        "WAYLAND_DISPLAY"
      ];
      prompt_prefix = "";
      # keybinding = [
      #   {
      #     binding = "Ctrl-q";
      #     action = "detach";
      #   }
      # ];
    };
  };
}
