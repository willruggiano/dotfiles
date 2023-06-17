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

  options.programs.hyprland = with types; {
    wallpapers = mkOption {
      type = attrsOf (
        types.submodule {
          options = {
            source = mkOption {
              type = path;
            };
          };
        }
      );
      default = {};
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };

      programs.flavours.items.hyprland = {
        template = ./hyprland.mustache;
      };

      user.packages = with pkgs; [
        hyprpaper
        hyprpicker
        slurp
        wl-clipboard
        wofi
      ];

      environment.loginShellInit = ''
        [[ "$(tty)" == /dev/tty1 ]] && exec Hyprland
      '';

      home.configFile = let
        hypr-keybinds = pkgs.writeTextFile {
          name = "hypr-keybinds.conf";
          text = import ./keybinds.conf.nix {inherit config pkgs;};
        };
      in {
        "hypr/hyprland.conf".text = import ./hyprland.conf.nix {inherit config hypr-keybinds lib pkgs;};
      };
    })
    (mkIf (cfg.wallpapers != {}) {
      home.configFile = {
        "hypr/hyprpaper.conf".text = import ./hyprpaper.conf.nix {inherit config lib;};
      };
    })
  ];
}
