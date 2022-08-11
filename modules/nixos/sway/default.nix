{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.sway;
in {
  options.programs.sway.wlr = with types; {
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
          wlr-randr
        ];

        wrapperFeatures.gtk = true;
      };

      environment.loginShellInit = ''
        [[ "$(tty)" == /dev/tty1 ]] && exec sway --unsupported-gpu
      '';

      environment.sessionVariables = {
        WLR_DRM_NO_ATOMIC = "1";
      };

      programs.waybar.enable = true;
      programs.xwayland.enable = true;

      programs.light.enable = true;
      user.extraGroups = ["video"];

      home.configFile = {
        "sway/config".text = import ./sway.nix {inherit pkgs;};
        "waybar/config".text = import ./waybar.nix {inherit config pkgs;};
        waybar = {
          source = ../../../.config/waybar;
          recursive = true;
        };
      };
    }
    (mkIf (!cfg.wlr.hardware-cursors) {
      environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    })
  ]);
}
