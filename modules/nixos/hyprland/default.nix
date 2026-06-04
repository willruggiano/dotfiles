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
      cursor = {
        size = mkOption {
          type = int;
          default = 32;
        };
        theme = mkOption {
          type = str;
          default = "McMojave";
        };
      };
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

        home.configFile = mkMerge [
          {
            "hypr/hyprland.lua".source = ./hyprland.lua;
            "wofi/config".text = ''
              key_down=Control_L-j
              key_up=Control_L-k
              key_expand=Control_L-l
              layer=overlay
            '';
          }
        ];

        environment = {
          loginShellInit = ''
            [[ "$(tty)" == /dev/tty1 ]] && exec Hyprland
          '';
          sessionVariables = let
            inherit (config.lib.stylix.colors) base00 base03 base06 base0A base0D;
            inherit (import ./lib.nix) rgb;
          in {
            BASE_00 = rgb base00;
            BASE_03 = rgb base03;
            BASE_06 = rgb base06;
            BASE_0A = rgb base0A;
            BASE_0D = rgb base0D;
            HYPRCURSOR_SIZE = cfg.cursor.size;
            HYPRCURSOR_THEME = cfg.cursor.theme;
            LATITUDE = builtins.toString config.location.latitude;
            LONGITUDE = builtins.toString config.location.longitude;
            NIXOS_OZONE_WL = 1;
            XDG_SESSION_TYPE = "wayland";
          };
          systemPackages = with pkgs; [
            grim
            slurp
            (pkgs.makeDesktopItem {
              name = "Screenshot";
              desktopName = "Screenshot";
              exec = let
                app = pkgs.writeShellApplication {
                  name = "screenshot";
                  runtimeInputs = [coreutils grim slurp];
                  text = ''
                    grim -g "$(slurp)" "$HOME/Downloads/screenshot-$(date -Is).png"
                  '';
                };
              in
                lib.getExe app;
            })
            wl-clipboard
            wlsunset
            wofi
            inputs.mcmojave-cursor.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        };

        xdg.portal = {
          config.common.default = ["hyprland" "gtk"];
        };
      }
      (mkIf config.hardware.nvidia.enable {
        environment.sessionVariables = {
          LIBVA_DRIVER_NAME = "nvidia";
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        };
      })
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
