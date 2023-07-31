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

      programs.flavours.items = {
        hyprland.template = ./hyprland.mustache;
        wofi.template = ./wofi.mustache;
      };

      environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

      environment.systemPackages = with pkgs; [
        grim
        hyprpaper
        hyprpicker
        slurp
        swaylock-effects
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

        screenlock-args = {
          screenshots = true;
          clock = true;
          indicator = true;
          indicator-thickness = 5;
          effect-blur = "7x5";
          effect-vignette = "0.5:0.5";
          ring-color = "bb00cc";
          key-hl-color = "880033";
          line-color = "00000000";
          inside-color = "00000088";
          separator-color = "00000000";
          grace = 2;
          fade-in = 0.2;
        };
        screenlock-cmd = concatStringsSep " " (
          [
            "${pkgs.swaylock-effects}/bin/swaylock"
            "-f" # daemonize
            "-e" # do not validate empty passwords
          ]
          ++ (mapAttrsToList (name: value:
            if builtins.typeOf value == "bool"
            then "--${name}"
            else "--${name}=${toString value}")
          screenlock-args)
        );
      in {
        "hypr/hyprland.conf".text = import ./hyprland.conf.nix {inherit config hypr-keybinds lib pkgs screenlock-cmd;};

        "wofi/config".text = ''
          key_down=Control_L-j
          key_up=Control_L-k
          key_expand=Control_L-l
          layer=overlay
        '';
        "wofi/style.css".source = config.programs.flavours.build.wofi;
      };

      security.pam.services.swaylock.text = ''
        # https://nixos.wiki/wiki/Sway#Swaylock_cannot_unlock_with_correct_password
        auth include login
      '';
    })
    (mkIf (cfg.wallpapers != {}) {
      home.configFile = {
        "hypr/hyprpaper.conf".text = import ./hyprpaper.conf.nix {inherit config lib;};
      };
    })
  ];
}
