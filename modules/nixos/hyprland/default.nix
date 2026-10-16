{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.hyprland;
in {
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
          # programs.hyprland = {
          #   package = inputs.hypr.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          #   portalPackage = inputs.hypr.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
          # };

          systemd.user.targets.hyprland-session = {
            description = "Hyprland graphical session";
            bindsTo = ["graphical-session.target"];
            after = ["graphical-session-pre.target"];
          };

          nix.settings = {
            substituters = ["https://hyprland.cachix.org"];
            trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
          };

          home.configFile = let
            switchWindow = pkgs.writeShellApplication {
              name = "switch_window.sh";
              runtimeInputs = with pkgs; [hyprland jq hyprlauncher];
              text = ''
                hyprctl clients -j | jq -r '.[] | (select(.pid != -1) | .pid | tostring) + " " + (select(.title != "") | .title)' | hyprlauncher -m | {
                  # shellcheck disable=SC2034
                  read -r pid title;
                  hyprctl dispatch "hl.dsp.focus({ window = 'pid:$pid' })"
                }
              '';
            };
          in {
            "hypr/hyprland.lua".source = pkgs.substitute {
              src = ./hyprland.lua;
              substitutions = ["--replace-fail" "@switchWindow@" (lib.getExe switchWindow)];
            };
          };

          environment = {
            loginShellInit = ''
              [[ "$(tty)" == /dev/tty1 ]] && start-hyprland
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
              screenrec = pkgs.makeDesktopItem {
                name = "Screenrec";
                desktopName = "Screenrec";
                exec = let
                  app = pkgs.writeShellApplication {
                    name = "screenrec";
                    runtimeInputs = [coreutils slurp wl-screenrec];
                    text = ''
                      wl-screenrec -g "$(slurp)" -f "$HOME/Downloads/screenrec-$(date -Is).mp4"
                    '';
                  };
                in
                  lib.getExe app;
              };
              screenshot = pkgs.makeDesktopItem {
                name = "Screenshot";
                desktopName = "Screenshot";
                exec = let
                  app = pkgs.writeShellApplication {
                    name = "screenshot";
                    runtimeInputs = [coreutils grim satty slurp wl-clipboard];
                    text = ''
                      grim -g "$(slurp)" -t ppm - | satty -f - --copy-command wl-copy --fullscreen --floating-hack -o "$HOME/Downloads/screenshot-$(date -Is).png"
                    '';
                  };
                in
                  lib.getExe app;
              };
              screenshot-display = pkgs.makeDesktopItem {
                name = "Screenshot (display output)";
                desktopName = "Screenshot (display output)";
                exec = let
                  app = pkgs.writeShellApplication {
                    name = "screenshot-display";
                    runtimeInputs = [coreutils grim satty slurp wl-clipboard];
                    text = ''
                      grim -g "$(slurp -o)" -t ppm - | satty -f - --copy-command wl-copy --fullscreen --floating-hack -o "$HOME/Downloads/screenshot-$(date -Is).png"
                    '';
                  };
                in
                  lib.getExe app;
              };
            in [
              brightnessctl
              grim
              hyprlauncher
              hyprshutdown
              mcmojave-cursor
              screenrec
              screenshot
              screenshot-display
              slurp
              wl-clipboard
              wl-screenrec
              wlsunset
            ];
          };

          xdg.portal = {
            config.common.default = ["hyprland" "gtk"];
          };
        }
        (let
          fonts = config.fonts.fontconfig.defaultFonts;
          fontSize = config.fonts.fontSize;
          theme = mode: palette:
            pkgs.writeText "hyprtoolkit-${mode}.conf" (
              ''
                # Generated by Nix
                font_family = ${builtins.head fonts.sansSerif}
                font_family_monospace = ${builtins.head fonts.monospace}
                font_size = ${toString fontSize}
                h1_size = ${toString (fontSize + 6)}
                h2_size = ${toString (fontSize + 4)}
                h3_size = ${toString (fontSize + 2)}
                rounding_large = 0
                rounding_small = 0
                small_font_size = ${toString (fontSize - 2)}
              ''
              + concatStringsSep "\n" (mapAttrsToList (name: color: "${name} = rgb(${removePrefix "#" color})") palette)
              + "\n"
            );
          dark = theme "dark" {
            accent = colors.base0C;
            accent_secondary = colors.base0D;
            alternate_base = colors.base02;
            background = colors.base01;
            base = colors.base00;
            bright_text = colors.base06;
            text = colors.base05;
          };
          light = theme "light" {
            accent = "0184bc";
            accent_secondary = "4078f2";
            alternate_base = "a0bcf8";
            background = "f0f0f0";
            base = "fafafa";
            bright_text = "1b2229";
            text = "383a42";
          };
        in
          mkIf config.services.darkman.enable {
            home.dataFile."darkman/hyprtoolkit".source = pkgs.writeShellScript "hyprtoolkit-theme" ''
              case "$1" in
                dark) target=${dark} ;;
                light) target=${light} ;;
                *) echo "invalid mode: $1" >&2; exit 1 ;;
              esac
              link_name="$HOME/.config/hypr/hyprtoolkit.conf"
              ${lib.getExe' pkgs.coreutils "ln"} -sf "$target" "$link_name"
            '';
          })
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
