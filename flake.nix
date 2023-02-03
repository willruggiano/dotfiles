{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:LnL7/nix-darwin/master";
    naersk.url = "github:nix-community/naersk";
    nix.url = "github:nixos/nix/master";
    nix-flake-templates = {
      url = "github:willruggiano/nix-flake-templates";
      flake = false;
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/nur";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    base16-templates-source.url = "github:chriskempson/base16-templates-source";
    base16-templates-source.flake = false;
    docker-ui-nvim.url = "github:willruggiano/docker-ui.nvim";
    hyprland.url = "github:hyprwm/hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    nvim-treesitter-master.url = "github:nvim-treesitter/nvim-treesitter";
    nvim-treesitter-master.flake = false;
    nil.url = "github:oxalica/nil";
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
    nixosModules = commonModules // (lib'.mapModules ./modules/nixos import);
  in
    utils.lib.mkFlake {
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
        inputs.naersk.overlay
        inputs.neovim.overlay
        inputs.nil.overlays.default
        inputs.nur.overlay
        inputs.spacebar.overlay
        inputs.utils.overlay
        inputs.zig.overlays.default
        inputs.nixpkgs-wayland.overlay
        (final: prev: {
          inherit (inputs.docker-ui-nvim.packages."${prev.system}") docker-ui-nvim;
          inherit (inputs.nixpkgs-stable.legacyPackages."${prev.system}") cmake-language-server;
          inherit (inputs) nvim-treesitter-master;
        })
        (final: prev: {
          # NOTE: Packages we want on the bleeding edge (but without needing to update nixpkgs too often).
          inherit (inputs.nixpkgs-master.legacyPackages."${prev.system}") nushell;
          inherit (inputs) base16-templates-source;
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
    };
}
