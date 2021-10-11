{ options, config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.desktop.libreoffice;
in
{
  options.modules.desktop.libreoffice = {
    enable = mkEnableOption "Enable libreoffice";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      libreoffice
    ];
  };
}
