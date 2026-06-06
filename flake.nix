{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-latest.url = "github:nixos/nixpkgs";
    nixos-cli.url = "github:nix-community/nixos-cli";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    campfire.url = "sourcehut:~bombadil/campfire";
    doom-one = {
      url = "github:NTBBloodbath/doom-one.nvim";
      flake = false;
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.55.2&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    hyprlauncher = {
      url = "github:hyprwm/hyprlauncher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        aquamarine.follows = "hyprland/aquamarine";
        hyprwire.follows = "hyprland/hyprwire";
        hyprutils.follows = "hyprland/hyprutils";
        hyprlang.follows = "hyprland/hyprlang";
        hyprtoolkit.follows = "hyprtoolkit";
      };
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprutils.follows = "hyprland/hyprutils";
        hyprlang.follows = "hyprland/hyprlang";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };
    hyprshutdown = {
      url = "github:hyprwm/hyprshutdown";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
        aquamarine.follows = "hyprland/aquamarine";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprtoolkit.follows = "hyprtoolkit";
        hyprutils.follows = "hyprland/hyprutils";
      };
    };
    hyprtoolkit = {
      url = "github:hyprwm/hyprtoolkit";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "hyprland/systems";
        aquamarine.follows = "hyprland/aquamarine";
        hyprlang.follows = "hyprland/hyprlang";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
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
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
        inputs.treefmt.flakeModule
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
          buildInputs = with pkgs; [just nix-output-monitor yubikey-manager];
          inputsFrom = [config.pre-commit.devShell];
          shellHook = let
            pkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
            luarc = pkgs.writeText "luarc.json" (builtins.toJSON {
              workspace.library = ["${pkg}/share/hypr/stubs"];
            });
          in ''
            ln -sf ${luarc} .luarc.json
          '';
        };
        pre-commit.settings = {
          hooks.treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };
        };
        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            fish_indent.enable = true;
            prettier.enable = true;
            ruff.enable = true;
            shfmt.enable = true;
            stylua.enable = true;
            taplo.enable = true;
            yamlfmt.enable = true;
          };
          settings.global.excludes = ["packages/base16-templates/nix/sources.json"];
        };
      };
    };

  nixConfig = {
    extra-substituters = ["https://watersucks.cachix.org"];
    extra-trusted-public-keys = [
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ];
  };
}
