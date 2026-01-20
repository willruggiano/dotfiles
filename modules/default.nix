{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules.default = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        {
          _module.args = {
            pkgs' = import inputs.nixpkgs-latest {
              inherit (config.nixpkgs) config;
              inherit (pkgs) system;
            };
          };
        }
        ./common/flavours
        ./common/kitty
        ./common/neovim
        ./common/qutebrowser
        ./common/weechat
        ./common/xplr
        ./common/aws.nix
        ./common/fonts.nix
        ./common/htop.nix
        ./common/nix.nix
        ./common/pass.nix
        ./common/sourcegraph.nix
        ./common/tendrel.nix
        ./common/wezterm.nix
        ./common/zk.nix
        ./nixos/brave
        ./nixos/fish
        ./nixos/git
        ./nixos/goxlr
        ./nixos/hyprland
        ./nixos/pipewire
        ./nixos/agenix.nix
        ./nixos/audio.nix
        ./nixos/autorandr-rs.nix
        ./nixos/backlight.nix
        ./nixos/blender.nix
        ./nixos/bluetooth.nix
        ./nixos/cachix.nix
        ./nixos/chromium.nix
        ./nixos/darkman.nix
        ./nixos/direnv.nix
        ./nixos/dropbox.nix
        ./nixos/dunst.nix
        ./nixos/email.nix
        ./nixos/expressvpn.nix
        ./nixos/firefox.nix
        ./nixos/fzf.nix
        ./nixos/keybase.nix
        ./nixos/keyd.nix
        ./nixos/libreoffice.nix
        ./nixos/mopidy.nix
        ./nixos/nix.nix
        ./nixos/nvidia.nix
        ./nixos/obs.nix
        ./nixos/postgres.nix
        ./nixos/remarkable.nix
        ./nixos/shell.nix
        ./nixos/spotify.nix
        ./nixos/ssh.nix
        ./nixos/starship.nix
        ./nixos/stylix.nix
        ./nixos/syncthing.nix
        ./nixos/trezor.nix
        ./nixos/utils.nix
        ./nixos/virtualisation.nix
        ./nixos/yubico.nix
        ./nixos/zsh.nix
        {
          imports = [inputs.home-manager.nixosModules.home-manager];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              ./home/gpg.nix
            ];
          };
        }
      ];

      config = {
        nixpkgs = {
          config = {
            allowBroken = true;
            allowUnfree = true;
          };
          overlays = [
            self.overlays.default
            inputs.hyprland.overlays.default
            inputs.hypridle.overlays.default
            inputs.hyprlock.overlays.default
            inputs.nur.overlays.default
          ];
        };

        nix = {
          nixPath = [
            "nixpkgs=${inputs.nixpkgs}"
            "nixpkgs-latest=${inputs.nixpkgs-latest}"
          ];
          registry = {
            nixpkgs.flake = inputs.nixpkgs;
            nixpkgs-latest.flake = inputs.nixpkgs-latest;
          };
          settings = {
            auto-optimise-store = true;
            experimental-features = "nix-command flakes";
            extra-sandbox-paths = ["/nix/var/cache/ccache"];
            substituters = [
              "https://nix-community.cachix.org"
              "https://nixpkgs-wayland.cachix.org"
              "https://willruggiano.cachix.org"
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
              "willruggiano.cachix.org-1:rz00ME8/uQfWe+tN3njwK5vc7P8GLWu9qbAjjJbLoSw="
            ];
            trusted-users = ["root" "@wheel"];
          };
          gc = {
            automatic = true;
            dates = "weekly";
          };
        };

        systemd.services.nix-daemon.serviceConfig = {
          MemoryAccounting = true;
          MemoryMax = "90%";
          OOMScoreAdjust = 500;
        };

        i18n.defaultLocale = "en_US.UTF-8";
        time.timeZone = "America/Los_Angeles";
      };
    };
  };
}
