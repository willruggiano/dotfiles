{
  description = "NixOS configurations";

  inputs = {
    self.submodules = true; # enable submodule fetching
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
    hypr = {
      url = "github:willruggiano/hyprnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj = {
      url = "github:jj-vcs/jj/v0.44.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj-gh = {
      url = "github:mrjones2014/jj-gh/jj-gh-v0.2.10";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcmojave-cursor = {
      url = "github:libadoxon/mcmojave-hyprcursor";
      inputs = {
        hyprcursor.follows = "hypr/hyprcursor";
        nixpkgs.follows = "hypr/nixpkgs";
        systems.follows = "hypr/systems";
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
            pkg = inputs.hypr.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
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
