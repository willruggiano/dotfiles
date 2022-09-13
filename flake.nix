{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nix.url = "github:nixos/nix/master";
    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    naersk.url = "github:nix-community/naersk";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/nur";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    docker-ui-nvim.url = "github:willruggiano/docker-ui.nvim";
    # emanote.url = "github:srid/emanote";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    spacebar.url = "github:cmacrae/spacebar";
    zig.url = "github:willruggiano/zig.nix";
  };

  outputs = {
    self,
    utils,
    nixpkgs,
    ...
  } @ inputs: let
    args = {inherit (self) lib;};
    lib' = import ./lib args inputs;
    commonModules = {dotfiles = import ./.;} // (lib'.mapModules ./modules/common import);
    darwinModules = commonModules // (lib'.mapModules ./modules/darwin import);
    nixosModules = commonModules // (lib'.mapModules ./modules/nixos import);
  in
    utils.lib.mkFlake {
      inherit self inputs nixosModules;

      lib =
        nixpkgs.lib.extend
        (final: prev: {
          inherit (lib') makeHome mapFilterAttrs mapModules reduceModules mapModulesRec reduceModulesRec mkOpt mkOpt';
        });

      supportedSystems = ["x86_64-darwin" "x86_64-linux"];
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.overlaysBuilder = channels: [
        self.overlay
        inputs.naersk.overlay
        inputs.neovim.overlay
        inputs.nur.overlay
        inputs.spacebar.overlay
        inputs.utils.overlay
        inputs.zig.overlays.default
        inputs.nixpkgs-wayland.overlay
        (final: prev: {
          inherit (inputs.docker-ui-nvim.packages."${prev.system}") docker-ui-nvim;
          inherit (inputs.nixpkgs-stable.legacyPackages."${prev.system}") cmake-language-server;
          # emanote = inputs.emanote.defaultPackage."${prev.system}";
        })
      ];

      hostDefaults.modules = [
        ./. # default.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = lib'.reduceModules ./modules/home import; # ++ [ inputs.emanote.homeManagerModule ];
        }
      ];

      hosts.ecthelion = rec {
        system = "x86_64-linux";
        modules = [
          {
            imports = lib'.reduceModules ./modules/nixos import;
          }
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
          {
            imports = lib'.reduceModules ./modules/nixos import;
          }
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
          {
            imports = lib'.reduceModules ./modules/nixos import;
          }
          ./hosts/orthanc
          inputs.home-manager.nixosModule
          {home-manager.users.saruman = import ./hosts/orthanc/home.nix;}
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
          {home-manager.users.wruggian = import ./hosts/88e9fe563b0b/home.nix;}
        ];
        specialArgs = {
          inherit (self) lib;
          inherit inputs system;
        };
        builder = inputs.darwin.lib.darwinSystem;
        output = "darwinConfigurations";
      };

      overlay = import ./packages/overlays.nix;
      overlays = utils.lib.exportOverlays {inherit (self) pkgs inputs;};

      outputsBuilder = channels: let
        pkgs = channels.nixpkgs;
      in {
        apps = {
          colorctl = utils.lib.mkApp {
            drv = pkgs.colorctl;
          };
          update-docsets = utils.lib.mkApp {
            drv = pkgs.docsets.update-docsets;
          };
          update-treesitter-parsers = utils.lib.mkApp {
            drv = pkgs.nvim-treesitter.update-grammars;
          };
        };

        checks = {
          pre-commit = inputs.pre-commit.lib."${pkgs.system}".run {
            src = ./.;
            hooks = let
              pre-commit-hooks = "${pkgs.pre-commit-hooks}/bin";
            in {
              alejandra.enable = true;
              check-executables-have-shebangs = {
                entry = "${pre-commit-hooks}/check-executables-have-shebangs";
                types = ["text" "executable"];
              };
              check-json = {
                enable = true;
                entry = "${pre-commit-hooks}/check-json";
                types = ["json"];
              };
              check-merge-conflict = {
                enable = true;
                entry = "${pre-commit-hooks}/check-merge-conflict";
                types = ["text"];
              };
              check-toml = {
                enable = true;
                entry = "${pre-commit-hooks}/check-toml";
                types = ["toml"];
              };
              check-yaml = {
                enable = true;
                entry = "${pre-commit-hooks}/check-yaml";
                types = ["yaml"];
              };
              end-of-file-fixer = {
                enable = true;
                entry = "${pre-commit-hooks}/end-of-file-fixer";
                types = ["text"];
              };
              stylua = {
                enable = true;
                types = ["file" "lua"];
              };
              trailing-whitespace = {
                enable = true;
                entry = "${pre-commit-hooks}/trailing-whitespace-fixer";
                types = ["text"];
              };
            };
          };
        };
        packages = utils.lib.exportPackages self.overlays channels;
        devShell = pkgs.stdenvNoCC.mkDerivation {
          name = "dotfiles";
          buildInputs = with pkgs; [fup-repl git niv nix-zsh-completions nodejs];
          inherit (self.checks."${pkgs.system}".pre-commit) shellHook;
        };
      };

      packages = {
        x86_64-darwin = {
          dev-laptop = self.darwinConfigurations.dev-laptop.system;
        };
      };
    };
}
