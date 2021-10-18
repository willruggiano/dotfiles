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
    rnix-lsp.url = github:nix-community/rnix-lsp/master;
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, utils, nixpkgs, ... } @ inputs:
    let
      args = { lib = self.lib; };
      lib' = import ./lib args;
      nixosModules = { dotfiles = import ./.; } // (self.lib.mapModules ./modules/nixos import);
    in
    utils.lib.mkFlake (
      {
        inherit self inputs nixosModules;

        lib = nixpkgs.lib.extend
          (final: prev: {
            inherit (lib') mapFilterAttrs mapModules mapModules' mapModulesRec mapModulesRec';
          });

        supportedSystems = [ "x86_64-darwin" "x86_64-linux" ];
        channelsConfig.allowUnfree = true;

        channels.nixpkgs.overlaysBuilder = channels: [
          self.overlay
          inputs.nur.overlay
          inputs.utils.overlay
        ];

        hostDefaults.modules = [
          ./. # default.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = self.lib.mapModulesRec' ./modules/home import;
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

        homes.dev-desktop = inputs.home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          stateVersion = "21.05";
          homeDirectory = "/home/wruggian";
          username = "wruggian";
          configuration = {
            imports = [
              ./hosts/dev-desktop/home.nix
            ];
          };
          pkgs = self.pkgs.${system}.nixpkgs;
          extraSpecialArgs = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
          extraModules = self.lib.mapModulesRec' ./modules/home import;
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

        packages.x86_64-linux.dev-desktop = self.homes.dev-desktop.activationPackage;
      }
    );
}
