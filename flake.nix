{
  description = "NixOS configuration";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/release-21.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-21.05";

    # Environment/system management
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... } @ inputs:
    let
      nixpkgsConfig = with inputs; rec {
        config = { allowUnfree = true; };
        overlays = with inputs; [
          (final: prev: {
            master = import nixpkgs-master { inherit (prev) system; inherit config; };
            unstable = import nixpkgs-unstable { inherit (prev) system; inherit config; };

            agenix = agenix.defaultPackage.${prev.system};
            kitty = final.unstable.kitty;
            neovim = neovim.packages.${prev.system}.neovim;
            nixUnstable = final.unstable.nixUnstable;
            zsh = final.unstable.zsh;
          })
        ];
      };
      overlays = [
        inputs.neovim.overlay
      ];
    in
    {
      nixosConfigurations = {
        mothership = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs = nixpkgsConfig;
            }
            nixos-hardware.nixosModules.system76
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            ./hosts/mothership/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bombadil = import ./home;
            }
            inputs.agenix.nixosModules.age
          ];
        };
      };
    };
}
