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

    services.openvpn.servers = listToAttrs (map (attr:
      nameValuePair "tendrel-${attr}" {
        config = "config ${config.age.secrets."tendrel-${attr}.ovpn".path}";
        autoStart = false;
      }) ["test" "beta"]);

    services.udev.packages = [pkgs.android-udev-rules];

    virtualisation.libvirtd.enable = true;
  };
}
