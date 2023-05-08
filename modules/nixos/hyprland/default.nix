{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.programs.hyprland;

  hyprland-default = pkgs.hyprland.override {
    enableXWayland = cfg.xwayland.enable;
    hidpiXWayland = cfg.xwayland.hidpi;
    inherit (cfg) nvidiaPatches;
  };
  hyprland-wrapped = hyprland-default.overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [pkgs.makeWrapper];
    postInstall = with pkgs;
      ''
        wrapProgram $out/bin/Hyprland \
          --prefix PATH : ${makeBinPath [hyprpaper pciutils]}
      ''
      + (optionalString cfg.nvidiaPatches ''
        wrapProgram $out/bin/Hyprland      \
          --set WLR_BACKEND vulkan         \
          --set WLR_RENDERER vulkan        \
          --set WLR_NO_HARDWARE_CURSORS 1
      '');
  });
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

      programs.hyprland.package = hyprland-wrapped;

      user.packages = with pkgs; [
        hyprpicker
        wl-clipboard
        wofi
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
        ];
      };

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
