{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.dropbox;
in {
  options.services.dropbox = {
    enable = mkEnableOption "Dropbox";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [maestral];

    systemd.user.services.maestral = {
      description = "Maestral daemon";
      wantedBy = ["default.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.maestral} start --foreground";
        Restart = "on-failure";
      };
    };
  };
}
