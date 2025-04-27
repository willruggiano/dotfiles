{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    agenix.url = "github:ryantm/agenix";
    base16-templates-source = {
      url = "github:chriskempson/base16-templates-source";
      flake = false;
    };
    doom-one = {
      url = "github:NTBBloodbath/doom-one.nvim";
      flake = false;
    };
    git-branchless.url = "github:arxanas/git-branchless";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.48.0&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "nixpkgs";
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
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    zenbones = {
      url = "github:mcchrish/zenbones.nvim";
      flake = false;
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
        inputs.git-hooks.flakeModule
        ./packages
        ./modules
        ./hosts
      ];

      systems = ["x86_64-linux"];
      perSystem = {
        config,
        lib,
        pkgs,
        self',
        ...
      }: {
        devShells.default = pkgs.mkShell {
          name = "dotfiles";
          buildInputs = with pkgs; [just nix-output-monitor];
          inputsFrom = [config.pre-commit.devShell];
        };
        pre-commit.settings.hooks = {
          alejandra.enable = true;
          ruff.enable = true;
          stylua.enable = true;
        };
      };
    };
}
