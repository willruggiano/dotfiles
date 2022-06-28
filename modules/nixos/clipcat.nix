{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.clipcat;
in {
  config = mkIf cfg.enable {
    user.packages = [
      (pkgs.writeShellApplication {
        name = "pass-clipcat";
        runtimeInputs = [pkgs.clipcat];
        text = ''
          pass clip
          cid=$(clipcatctl list | cut -d: -f1 | head -n1)
          clipcatctl promote "$cid" >/dev/null
          clipcatctl remove "$cid"
        '';
      })
    ];

    home.configFile = {
      "clipcat/clipcatd.toml".text = ''
        daemonize = false
        max_history = 50
        history_file_path = '/home/${config.user.name}/.cache/clipcat/clipcatd/db'
        log_level = 'INFO'

        [monitor]
        load_current = true
        enable_clipboard = true
        enable_primary = false

        [grpc]
        host = '127.0.0.1'
        port = 45045
      '';

      "clipcat/clipcatctl.toml".text = ''
        server_host = '127.0.0.1'
        server_port = 45045
        log_level = 'INFO'
      '';

      "clipcat/clipcat-menu.toml".text = ''
        server_host = '127.0.0.1'
        server_port = 45045
        finder = 'fzf'
      '';
    };
  };
}
