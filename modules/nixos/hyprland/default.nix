{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.programs.hyprland;
in {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = mkMerge [
    {
      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };

      programs.flavours.items.hyprland = {
        file = "~/.config/hypr/colors.conf";
        template = "custom/hypr";
      };
    }
    (mkIf
    cfg.enable {
      environment.loginShellInit = ''
        [[ "$(tty)" == /dev/tty1 ]] && exec Hyprland
      '';

      home.configFile = {
        hypr = {
          source = ../../../.config/hypr;
          recursive = true;
        };

        "hypr/keybinds.conf".text = import ./keybinds.conf.nix {inherit pkgs;};
      };
    })
  ];
}
