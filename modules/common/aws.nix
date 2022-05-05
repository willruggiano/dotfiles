{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.aws;
in {
  options.programs.aws = {
    enable = mkEnableOption "Enable aws";
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.awscli];
  };
}
