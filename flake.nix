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
    git-branchless.url = "github:arxanas/git-branchless";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    hypridle.url = "github:hyprwm/hypridle/v0.1.1";
    hyprland.url = "github:hyprwm/hyprland/v0.29.1";
    hyprlock.url = "github:hyprwm/hyprlock/v0.2.0";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    neovim.url = "github:willruggiano/neovim.drv";
    nil.url = "github:oxalica/nil";
    nix-flake-templates.flake = false;
    nix-flake-templates.url = "github:willruggiano/nix-flake-templates";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix2container.url = "github:nlewo/nix2container";
    nom.url = "github:maralorn/nix-output-monitor";
    nur.url = "github:nix-community/nur";
    nurl.url = "github:nix-community/nurl";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    stylix.url = "github:danth/stylix";
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
          inherit (inputs.home-manager.lib) hm;
          inherit (lib') makeHome mapFilterAttrs mapModules reduceModules mapModulesRec reduceModulesRec mkOpt mkOpt';
        });

      supportedSystems = ["x86_64-linux"];
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.overlaysBuilder = channels: [
        self.overlay
        inputs.hyprpaper.overlays.default
        inputs.hyprpicker.overlays.default
        inputs.nil.overlays.default
        inputs.nur.overlay
        inputs.utils.overlay
        (final: prev: {
          inherit (inputs) base16-templates-source;
          nix-output-monitor = inputs.nom.packages."${prev.system}".default;
          nurl = inputs.nurl.packages."${prev.system}".default;
        })
        (final: prev: {
          inherit (inputs.nixpkgs-stable.legacyPackages."${prev.system}") cmake-language-server;
          inherit (inputs.nixpkgs-master.legacyPackages."${prev.system}") brave;
          inherit (inputs.git-branchless.packages."${prev.system}") git-branchless;
          inherit (inputs.hypridle.packages."${prev.system}") hypridle;
          hyprlock = inputs.hyprlock.packages."${prev.system}".default.override {inherit (final) mesa;};
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
          inputs.stylix.nixosModules.stylix
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
          inputs.stylix.nixosModules.stylix
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

      outputsBuilder = channels: {
        packages = utils.lib.exportPackages self.overlays channels;
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
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        devenv.shells.default = {
          name = "dotfiles";
          packages = with pkgs; [just niv nix-output-monitor];
          pre-commit.hooks = {
            alejandra.enable = true;
            ruff.enable = true;
            stylua.enable = true;
          };
          scripts = {
            update-docsets.exec = let
              inherit (self.packages."${system}".docsets) update-docsets;
            in ''
              ${update-docsets}/bin/update-docsets ./packages/docsets
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
