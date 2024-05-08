{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-latest.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    agenix.url = "github:ryantm/agenix";
    base16-templates-source = {
      url = "github:chriskempson/base16-templates-source";
      flake = false;
    };
    devenv.url = "github:cachix/devenv";
    git-branchless.url = "github:arxanas/git-branchless";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland/v0.38.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        systems.follows = "hyprland/systems";
      };
    };
    nix-flake-templates = {
      url = "github:willruggiano/nix-flake-templates";
      flake = false;
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nom.url = "github:maralorn/nix-output-monitor";
    nur.url = "github:nix-community/nur";
    nurl.url = "github:nix-community/nurl";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    flake-parts,
    nixpkgs,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
        ./packages
        ./modules
        ./hosts
      ];

      systems = ["x86_64-linux"];
      perSystem = {
        lib,
        pkgs,
        self',
        ...
      }: {
        devenv.shells.default = {
          name = "dotfiles";
          containers = lib.mkForce {};
          packages = with pkgs; [just niv nix-output-monitor];
          pre-commit.hooks = {
            alejandra.enable = true;
            ruff.enable = true;
            stylua.enable = true;
          };
          scripts = {
            update-docsets.exec = let
              inherit (pkgs.docsets) update-docsets;
            in ''
              ${lib.getExe update-docsets} ./packages/docsets
              git commit -am 'chore: update docsets'
            '';
            update-neovim.exec = ''
              nix flake lock --update-input neovim
              git commit -am 'chore: update neovim'
            '';
          };
        };
      };
    };
}
