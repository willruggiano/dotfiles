{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-latest.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        darwin.follows = "";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    base16-templates-source = {
      url = "github:chriskempson/base16-templates-source";
      flake = false;
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        cachix.follows = "";
        flake-compat.follows = "";
        nix.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "git-hooks";
      };
    };
    git-branchless = {
      url = "github:arxanas/git-branchless";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      # url = "https://github.com/hyprwm/hyprland?ref=v0.41.2";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        hyprlang.follows = "hyprland/hyprlang";
        systems.follows = "hyprland/systems";
      };
    };
    mcmojave-cursor = {
      url = "github:libadoxon/mcmojave-hyprcursor";
      inputs = {
        hyprcursor.follows = "hyprland/hyprcursor";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    nix-flake-templates = {
      url = "github:willruggiano/nix-flake-templates";
      flake = false;
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/nur";
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        flake-compat.follows = "";
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
      flake = {
        autoUpdateInputs = [
          "agenix"
          "base16-templates-source"
          "devenv"
          "git-branchless"
          "git-hooks"
          "home-manager"
          "nix-flake-templates"
          "nixos-hardware"
          "nixpkgs-latest"
          "nur"
          "stylix"
        ];
      };

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
        };
      };
    };
}
