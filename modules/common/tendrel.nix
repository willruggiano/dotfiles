{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.tendrel;
in {
  options.tendrel = {
    enable = mkEnableOption "tendrel";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      awscli2
    ];
  };
}
