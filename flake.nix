{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix.url = "github:nixos/nix/master";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/nur";

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
          rnix-lsp = inputs.rnix-lsp.defaultPackage."${system}";
        };
    in
    {
      overlay = overlay;
      overlays = mapModules ./overlays import // { inherit (inputs.nur) overlay; };

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
              imports = [
                # We only need a subset of things
                # TODO: If we could find a way for the home modules to see our custom options we'd be in business.
                ./home/development.nix
                ./home/fzf.nix
                ./home/git.nix
                ./home/neovim.nix
                ./home/shell.nix
              ];
              nixpkgs = {
                overlays = [
                  overlay
                ];
              };
            };
          };
      };

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      devShell."${system}" = import ./shell.nix { inherit pkgs; };
    };
}
