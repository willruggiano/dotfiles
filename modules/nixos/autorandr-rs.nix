{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.autorandrd;
in {
  options.services.autorandrd = {
    enable = mkEnableOption "Enable autorandrd";
    config = mkOption {
      description = "The configuration file, in TOML";
      apply = path:
        if lib.isStorePath path
        then path
        else builtins.path {inherit path;};
    };
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.autorandr-rs];

    systemd.user.services.monitor-layout = {
      description = "monitor-layout daemon";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session-pre.target"];
      serviceConfig = {
        ExecStart = "${pkgs.autorandr-rs}/bin/monitor-layout daemon ${cfg.config}";
        Restart = "always";
      };
    };
  };
}
