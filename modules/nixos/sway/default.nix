{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.sway;
in {
  options.programs.sway.wlr = {
    hardware-cursors = mkEnableOption "wlr hardware cursor support";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.sway = {
        extraPackages = with pkgs; [
          dmenu-wayland
          swayidle
          swaylock
          wl-clipboard
        ];

        wrapperFeatures.gtk = true;
      };

      # environment.loginShellInit = ''
      #   [[ "$(tty)" == /dev/tty1 ]] && exec sway
      # '';

      programs.waybar.enable = true;

      programs.light.enable = true;
      user.extraGroups = ["video"];

      home.configFile."sway/config".text = import ./sway.nix {inherit pkgs;};
      home.configFile."waybar/config".text = import ./waybar.nix {inherit pkgs;};
      home.configFile = {
        waybar = {
          source = ../../../.config/waybar;
          recursive = true;
        };
      };
    }
    (mkIf (!cfg.wlr.hardware-cursors) {
      environment.variables.WLR_NO_HARDWARE_CURSORS = "1";
    })
  ]);
}
