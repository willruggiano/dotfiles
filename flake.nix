{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    agenix.url = "github:ryantm/agenix";
    base16-templates-source.flake = false;
    base16-templates-source.url = "github:chriskempson/base16-templates-source";
    devenv.url = "github:cachix/devenv";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    hyprland.url = "github:hyprwm/hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    neovim.url = "github:willruggiano/neovim.drv";
    nil.url = "github:oxalica/nil";
    nix-flake-templates.flake = false;
    nix-flake-templates.url = "github:willruggiano/nix-flake-templates";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/nur";
    nurl.url = "github:nix-community/nurl";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = {
    self,
    flake-parts,
    utils,
    nixpkgs,
    ...
  } @ inputs: let
    args = {inherit (self) lib;};
    lib' = import ./lib args inputs;
    commonModules = {dotfiles = import ./.;} // (lib'.mapModules ./modules/common import);
    nixosModules = commonModules // (lib'.mapModules ./modules/nixos import);

    flake = utils.lib.mkFlake {
      inherit self inputs nixosModules;

      lib =
        nixpkgs.lib.extend
        (final: prev: {
          inherit (lib') makeHome mapFilterAttrs mapModules reduceModules mapModulesRec reduceModulesRec mkOpt mkOpt';
        });

      supportedSystems = ["x86_64-linux"];
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.overlaysBuilder = channels: [
        self.overlay
        inputs.hyprland.overlays.default
        inputs.hyprpaper.overlays.default
        inputs.hyprpicker.overlays.default
        inputs.nil.overlays.default
        inputs.nixpkgs-wayland.overlay
        inputs.nur.overlay
        inputs.utils.overlay
        (final: prev: {
          inherit (inputs) base16-templates-source;
          nurl = inputs.nurl.packages."${prev.system}".default;
        })
        (final: prev: {
          inherit (inputs.nixpkgs-stable.legacyPackages."${prev.system}") cmake-language-server;
          inherit (inputs.nixpkgs-master.legacyPackages."${prev.system}") nushell qutebrowser-qt6;
        })
      ];

      hostDefaults.modules = [
        ./. # default.nix
        {
          imports = lib'.reduceModules ./modules/nixos import;
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = lib'.reduceModules ./modules/home import;
        }
      ];

      hosts.ecthelion = rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/ecthelion
          inputs.home-manager.nixosModule
          {home-manager.users.bombadil = import ./hosts/ecthelion/home.nix;}
        ];
        specialArgs = {
          inherit (self) lib;
          inherit inputs system;
        };
      };

      hosts.mothership = rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/mothership
          inputs.home-manager.nixosModule
          {home-manager.users.bombadil = import ./hosts/mothership/home.nix;}
        ];
        specialArgs = {
          inherit (self) lib;
          inherit inputs system;
        };
      };

      hosts.orthanc = rec {
        system = "aarch64-linux";
        modules = [
          ./hosts/orthanc
          inputs.home-manager.nixosModule
          {home-manager.users.saruman = import ./hosts/orthanc/home.nix;}
        ];
        specialArgs = {
          inherit (self) lib;
          inherit inputs system;
        };
      };

      overlay = import ./packages/overlays.nix;
      overlays = utils.lib.exportOverlays {inherit (self) pkgs inputs;};

      outputsBuilder = channels: let
        pkgs = channels.nixpkgs;
      in {
        apps = {
          bump-neovim = utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "bump-neovim" ''
              nix flake lock --update-input neovim
              git commit -am 'bump: neovim'
            '';
          };
          update-docsets = utils.lib.mkApp {
            drv = pkgs.docsets.update-docsets;
          };
          update-treesitter-parsers = utils.lib.mkApp {
            drv = pkgs.nvim-treesitter.update-grammars;
          };
        };
        packages = utils.lib.exportPackages self.overlays channels;
        devShell = pkgs.stdenvNoCC.mkDerivation {
          name = "dotfiles";
          buildInputs = with pkgs; [fup-repl git niv nodejs];
          shellHook = "";
        };
      };
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      inherit flake;
      imports = [
        inputs.devenv.flakeModule
        inputs.pre-commit.flakeModule
      ];
      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {
        devenv.shells.default = {
          name = "dotfiles";
          packages = with pkgs; [niv];

          pre-commit.hooks = {
            alejandra.enable = true;
          };
        };
      };
    };
}
