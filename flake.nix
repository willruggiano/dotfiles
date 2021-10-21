{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus/v1.3.0;

    nix.url = github:nixos/nix/master;
    nixos-hardware.url = github:nixos/nixos-hardware;
    nur.url = github:nix-community/nur;

    home-manager.url = github:nix-community/home-manager/release-21.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    emanote.url = github:srid/emanote;
  };

  outputs = { self, utils, nixpkgs, ... } @ inputs:
    let
      args = { lib = self.lib; };
      lib' = import ./lib args inputs;
      nixosModules = { dotfiles = import ./.; } // (self.lib.mapModules ./modules/nixos import);
    in
    utils.lib.mkFlake (
      {
        inherit self inputs nixosModules;

        lib = nixpkgs.lib.extend
          (final: prev: {
            inherit (lib') makeHome mapFilterAttrs mapModules reduceModules mapModulesRec reduceModulesRec;
          });

        supportedSystems = [ "x86_64-darwin" "x86_64-linux" ];
        channelsConfig.allowUnfree = true;

        channels.nixpkgs.overlaysBuilder = channels: [
          (final: prev: {
            emanote = inputs.emanote.defaultPackage.${prev.system};
          })
          self.overlay
          inputs.nur.overlay
          inputs.utils.overlay
        ];

        hostDefaults.modules = [
          ./. # default.nix
          inputs.home-manager.nixosModule
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = self.lib.reduceModules ./modules/home import;
          }
        ];

        hosts.mothership = rec {
          system = "x86_64-linux";
          modules = [
            ./hosts/mothership
            { home-manager.users.bombadil = import ./hosts/mothership/home.nix; }
          ];
          specialArgs = {
            inherit (self) lib;
            inherit inputs system;
          };
        };

        homes.dev-desktop = self.lib.makeHome ./hosts/dev-desktop {
          system = "x86_64-linux";
          username = "wruggian";
        };
        homes."88e9fe563b0b" = self.lib.makeHome ./hosts/88e9fe563b0b rec {
          system = "x86_64-darwin";
          username = "wruggian";
          homeDirectory = "/Users/${username}";
        };

        overlay = import ./packages { inherit inputs; };
        overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; };

        outputsBuilder = channels:
          let pkgs = channels.nixpkgs; in
          {
            packages = utils.lib.exportPackages self.overlays channels;
            devShell = pkgs.stdenvNoCC.mkDerivation {
              name = "dotfiles";
              buildInputs = with pkgs; [ fup-repl git nix-zsh-completions ];
              shellHook = ''
                export FLAKE=$(pwd)
                export PATH=$FLAKE/bin:$PATH
              '';
            };
          };

        packages = {
          x86_64-darwin = {
            "88e9fe563b0b" = self.homes."88e9fe563b0b".activationPackage;
          };
          x86_64-linux = {
            dev-desktop = self.homes.dev-desktop.activationPackage;
          };
        };
      }
    );
}
