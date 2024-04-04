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

  options.programs = {
    hyprland = with types; {
      extensions = {
        hypridle.enable = mkEnableOption "hypridle";
        hyprlock = {
          enable = mkEnableOption "hyprlock";
          monitor = mkOption {
            type = str;
          };
        };
      };
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
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        nix.settings = {
          substituters = ["https://hyprland.cachix.org"];
          trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        };

        home.configFile = let
          hypr-keybinds = pkgs.writeTextFile {
            name = "hypr-keybinds.conf";
            text = import ./keybinds.conf.nix {inherit config lib pkgs;};
          };
        in
          mkMerge [
            {
              "hypr/hyprland.conf".text = import ./hyprland.conf.nix {inherit config hypr-keybinds lib pkgs;};

              "wofi/config".text = ''
                key_down=Control_L-j
                key_up=Control_L-k
                key_expand=Control_L-l
                layer=overlay
              '';
              # "wofi/style.css".source = config.programs.flavours.build.wofi;
            }
            (mkIf (cfg.wallpapers != {}) {
              home.configFile = {
                "hypr/hyprpaper.conf".text = import ./hyprpaper.conf.nix {inherit config lib;};
              };
            })
          ];

        programs.flavours.items = {
          wofi.template = ./wofi.mustache;
        };

        environment = {
          loginShellInit = ''
            [[ "$(tty)" == /dev/tty1 ]] && exec Hyprland
          '';
          sessionVariables = {
            NIXOS_OZONE_WL = "1";
            WLR_NO_HARDWARE_CURSORS = "1";
          };
          systemPackages = with pkgs; [
            grim
            hyprpaper
            slurp
            wl-clipboard
            wofi
          ];
        };
      }
      (mkIf cfg.extensions.hyprlock.enable {
        environment.systemPackages = [pkgs.hyprlock];
        home.configFile = {
          "hypr/hyprlock.conf".text = import ./hyprlock.conf.nix {
            inherit (config.lib.stylix) colors;
            inherit (cfg.extensions.hyprlock) monitor;
          };
        };
        security.pam.services.hyprlock.text = "auth include login";
      })
      (mkIf cfg.extensions.hypridle.enable {
        home.configFile = {
          "hypr/hypridle.conf".source = ./hypridle.conf;
        };
      })
    ]
  );
}
