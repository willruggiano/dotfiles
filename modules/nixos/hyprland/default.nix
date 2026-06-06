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

  config = let
    inherit (config.lib.stylix) colors;
  in
    mkIf cfg.enable (
      mkMerge [
        {
          nix.settings = {
            substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
          };

          home.configFile = let
            fonts = config.fonts.fontconfig.defaultFonts;
          in {
            "hypr/hyprland.lua".source = ./hyprland.lua;
            "hypr/hyprtoolkit.conf".text = ''
              # Generate by Nix
              background = ${colors.withHashtag.base01}
              base = ${colors.withHashtag.base00}
              text = ${colors.withHashtag.base05}
              alternate_base = ${colors.withHashtag.base02}
              bright_text = ${colors.withHashtag.base06}
              accent = ${colors.withHashtag.base0C}
              accent_secondary = ${colors.withHashtag.base0D}
              h1_size = 20
              h2_size = 18
              h3_size = 16
              font_size = 14
              small_font_size = 12
              # icon_theme = ?
              font_family = ${builtins.head fonts.sansSerif}
              font_family_monospace = ${builtins.head fonts.monospace}
              rounding_large = 0
              rounding_small = 0
            '';
          };

          environment = {
            loginShellInit = ''
              [[ "$(tty)" == /dev/tty1 ]] && exec Hyprland
            '';

            sessionVariables = {
              BASE_00 = colors.withHashtag.base00;
              BASE_01 = colors.withHashtag.base01;
              BASE_02 = colors.withHashtag.base02;
              BASE_05 = colors.withHashtag.base05;
              BASE_09 = colors.withHashtag.base09;
              BASE_0B = colors.withHashtag.base0B;
              BASE_0D = colors.withHashtag.base0D;
              HYPRCURSOR_SIZE = cfg.cursor.size;
              HYPRCURSOR_THEME = cfg.cursor.theme;
              LATITUDE = builtins.toString config.location.latitude;
              LONGITUDE = builtins.toString config.location.longitude;
              NIXOS_OZONE_WL = 1;
              XDG_SESSION_TYPE = "wayland";
            };

            systemPackages = with pkgs; let
              inherit (pkgs.stdenv.hostPlatform) system;
              mcmojave-cursor = inputs.mcmojave-cursor.packages.${system}.default;
              screenshot = pkgs.makeDesktopItem {
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
              };
            in [
              grim
              hyprlauncher
              hyprshutdown
              mcmojave-cursor
              screenshot
              slurp
              wl-clipboard
              wlsunset
            ];
          };

          xdg.portal = {
            config.common.default = ["hyprland" "gtk"];
          };
        }
        (mkIf cfg.extensions.hypridle.enable {
          environment.systemPackages = [pkgs.hypridle];
          home.configFile = {
            "hypr/hypridle.conf".source = ./hypridle.conf;
          };
        })
        (mkIf cfg.extensions.hyprlock.enable {
          environment.systemPackages = [pkgs.hyprlock];
          home.configFile = {
            "hypr/hyprlock.conf".text = import ./hyprlock.conf.nix {
              inherit (cfg.extensions.hyprlock) monitor;
              inherit config;
            };
          };
          security.pam.services.hyprlock.text = "auth include login";
        })
        (mkIf config.hardware.nvidia.enable {
          environment.sessionVariables = {
            LIBVA_DRIVER_NAME = "nvidia";
            GBM_BACKEND = "nvidia-drm";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          };
        })
      ]
    );
}
