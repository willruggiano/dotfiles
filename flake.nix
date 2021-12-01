{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/9651c19f895382702a6257c4da08d14a66488782";

    nix.url = "github:nixos/nix/master";
    darwin.url = "github:LnL7/nix-darwin/master";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/nur";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    emanote.url = "github:srid/emanote";
    emanote.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    spacebar.url = "github:cmacrae/spacebar/v1.3.0";
  };

  outputs = { self, utils, nixpkgs, ... } @ inputs:
    let
      args = { inherit (self) lib; };
      lib' = import ./lib args inputs;
      commonModules = { dotfiles = import ./.; } // (lib'.mapModules ./modules/common import);
      darwinModules = commonModules // (lib'.mapModules ./modules/darwin import);
      nixosModules = commonModules // (lib'.mapModules ./modules/nixos import);
    in
    utils.lib.mkFlake {
      inherit self inputs nixosModules;

      lib = nixpkgs.lib.extend
        (final: prev: {
          inherit (lib') makeHome mapFilterAttrs mapModules reduceModules mapModulesRec reduceModulesRec mkOpt mkOpt';
        });

      supportedSystems = [ "x86_64-darwin" "x86_64-linux" ];
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.overlaysBuilder = channels: [
        self.overlay
        inputs.neovim.overlay
        inputs.nur.overlay
        inputs.spacebar.overlay
        inputs.utils.overlay
        (final: prev: nixpkgs.lib.optionalAttrs (!prev.isFakePkgs or false) {
          emanote = inputs.emanote.defaultPackage."${prev.system}";
        })
      ];

      hostDefaults.modules = [
        ./. # default.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = lib'.reduceModules ./modules/home import;
        }
      ];

      hosts.mothership = rec {
        system = "x86_64-linux";
        modules = [
          {
            imports = lib'.reduceModules ./modules/nixos import;
          }
          ./hosts/mothership
          inputs.home-manager.nixosModule
          { home-manager.users.bombadil = import ./hosts/mothership/home.nix; }
        ];
        specialArgs = {
          inherit (self) lib;
          inherit inputs system;
        };
      };

      hosts.dev-laptop = rec {
        system = "x86_64-darwin";
        modules = [
          {
            imports = lib'.reduceModules ./modules/darwin import;
          }
          ./hosts/88e9fe563b0b
          inputs.home-manager.darwinModule
          { home-manager.users.wruggian = import ./hosts/88e9fe563b0b/home.nix; }
        ];
        specialArgs = {
          inherit (self) lib;
          inherit inputs system darwinModules;
        };
        builder = inputs.darwin.lib.darwinSystem;
        output = "darwinConfigurations";
      };

      homes.dev-desktop = lib'.makeHome ./hosts/dev-desktop {
        system = "x86_64-linux";
        username = "wruggian";
      };

      overlay = import ./packages { inherit inputs; };
      overlays = utils.lib.exportOverlays { inherit (self) pkgs inputs; };

      outputsBuilder = channels:
        let pkgs = channels.nixpkgs; in
        {
          packages = utils.lib.exportPackages self.overlays channels;
          devShell = pkgs.stdenvNoCC.mkDerivation {
            name = "dotfiles";
            buildInputs = with pkgs; [ fup-repl git nix-zsh-completions nodejs ];
            shellHook = ''
              export FLAKE=$(pwd)
              export PATH=$FLAKE/bin:$PATH
            '';
          };
        };

      packages = {
        x86_64-darwin = {
          dev-laptop = self.darwinConfigurations.dev-laptop.system;
        };
        x86_64-linux = {
          dev-desktop = self.homes.dev-desktop.activationPackage;
        };
      };
    };
}
