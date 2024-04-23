{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.remarkable;
in {
  options.services.remarkable.enable = lib.mkEnableOption "remarkable";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [restream];

    systemd.user.services.restream = {
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.restream} -p -c -s remarkable";
      };
    };
  };
}
