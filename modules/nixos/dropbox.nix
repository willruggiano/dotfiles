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
    package = mkPackageOption pkgs "dropbox" {};
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [dropbox-cli];

    systemd.user.services.dropbox = {
      description = "dropbox";
      wantedBy = ["default.target"];
      # environment = {
      #   QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      #   QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
      # };
      serviceConfig = {
        Type = "forking";
        Restart = "on-failure";
        KillMode = "control-group";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStart = "${cfg.package}/bin/dropbox start";
        # Hardening
        PrivateTmp = true;
        ProtectSystem = "full";
        Nice = 10;
      };
    };
  };
}
