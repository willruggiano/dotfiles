{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.libreoffice;
in {
  options.programs.libreoffice = {
    enable = mkEnableOption "Enable libreoffice";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
    ];
  };
}
