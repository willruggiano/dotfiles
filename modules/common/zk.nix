{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.zk;
in {
  options.programs.zk = {
    enable = mkEnableOption "Enable zk";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.zk];

    home.configFile.zk = {
      source = ../../.config/zk;
      recursive = true;
    };
  };
}
