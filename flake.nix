{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    agenix.url = "github:ryantm/agenix";
    base16-templates-source.flake = false;
    base16-templates-source.url = "github:chriskempson/base16-templates-source";
    devenv.url = "github:cachix/devenv";
    git-branchless.url = "github:arxanas/git-branchless";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hypridle.url = "github:hyprwm/hypridle/v0.1.1";
    hyprland.url = "github:hyprwm/hyprland/v0.37.1";
    hyprlock.url = "github:hyprwm/hyprlock/v0.2.0";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nix-flake-templates.flake = false;
    nix-flake-templates.url = "github:willruggiano/nix-flake-templates";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nom.url = "github:maralorn/nix-output-monitor";
    nur.url = "github:nix-community/nur";
    nurl.url = "github:nix-community/nurl";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    stylix.url = "github:danth/stylix";
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
        inputs.pre-commit.flakeModule
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
