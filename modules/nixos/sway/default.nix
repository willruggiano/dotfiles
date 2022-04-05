{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.sway;
in {
  config = mkIf cfg.enable {
    programs.sway = {
      extraPackages = with pkgs; [
        dmenu-wayland
        swayidle
        swaylock
        wl-clipboard
      ];

      wrapperFeatures.gtk = true;
    };

    environment.loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && exec sway
    '';

    programs.waybar.enable = true;

    programs.light.enable = true;
    user.extraGroups = ["video"];

    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;

    home.configFile."sway/config".text = import ./sway.nix {inherit pkgs;};
    home.configFile."waybar/config".text = import ./waybar.nix {inherit pkgs;};
    home.configFile = {
      waybar = {
        source = ../../../.config/waybar;
        recursive = true;
      };
    };
  };
}
