{
  config,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  cfg = config.tendrel;
in {
  options.tendrel = {
    enable = mkEnableOption "tendrel";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      awscli2
    ];

    services.udev.packages = [pkgs.android-udev-rules];

    virtualisation.libvirtd.enable = true;
  };
}
