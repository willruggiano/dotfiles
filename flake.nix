{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix.url = "github:nixos/nix/master";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.url = "github:nix-community/rnix-lsp/master";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";

      inherit (lib.my) mapModules mapModulesRec mapSystems;

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs = mkPkgs nixpkgs [ self.overlay ];

      lib = nixpkgs.lib.extend
        (self: super: {
          my = import ./lib { inherit inputs pkgs; lib = self; };
        });

      overlay =
        final: prev: {
          my = self.packages."${system}";
          neovim-master = inputs.neovim.defaultPackage."${system}";
          rnix-lsp-master = inputs.rnix-lsp.defaultPackage."${system}";
        };
    in
    {
      overlay = overlay;

      overlays = mapModules ./overlays import;

      nixosModules = { dotfiles = import ./.; } // mapModulesRec ./modules import;
      nixosConfigurations = mapSystems ./nixos/configurations { };

      homeManagerConfigurations = {
        dev-dsk-wruggian-2b-68c3f3ef = inputs.home-manager.lib.homeManagerConfiguration
          {
            system = system;
            stateVersion = "21.05";
            homeDirectory = "/home/wruggian";
            username = "wruggian";
            configuration = {
              imports = [ ./home ];
              nixpkgs = {
                overlays = [ overlay ];
              };
            };
          };
      };

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}
