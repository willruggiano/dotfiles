{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules.default = {
      config,
      pkgs,
      system,
      ...
    }: {
      imports = [
        ./common/docsets
        ./common/flavours
        ./common/kitty
        ./common/neovim
        ./common/qutebrowser
        ./common/xplr
        ./common/aws.nix
        ./common/bat.nix
        ./common/fonts.nix
        ./common/htop.nix
        ./common/nix.nix
        ./common/pass.nix
        ./common/slack.nix
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
        ./nixos/bat.nix
        ./nixos/blender.nix
        ./nixos/bluetooth.nix
        ./nixos/cachix.nix
        ./nixos/chromium.nix
        ./nixos/direnv.nix
        ./nixos/discord.nix
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
        ./nixos/pulseaudio.nix
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
          imports = [inputs.home-manager.nixosModule];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              ./home/gpg.nix
            ];
          };
        }
      ];

      nixpkgs = {
        config = {
          allowBroken = true;
          allowUnfree = true;
        };
        overlays = [
          self.overlays.default
          inputs.git-branchless.overlays.default
          inputs.hyprland.overlays.default
          inputs.hypridle.overlays.default
          inputs.hyprlock.overlays.default
          inputs.hyprpaper.overlays.default
          inputs.nur.overlay
          inputs.nurl.overlays.default
          (final: prev: {
            inherit (inputs) base16-templates-source;
            git-branchless = prev.git-branchless.overrideAttrs (_: {
              # patches in the nixpkgs definition have been merged
              patches = [];
            });
            nix-output-monitor = inputs.nom.packages."${prev.system}".default;
          })
        ];
      };

      nix = {
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "nixpkgs-latest=${inputs.nixpkgs-latest}"
          "nixos-stable=${inputs.nixpkgs-stable}"
        ];
        registry.nixpkgs.flake = inputs.nixpkgs;
        settings = {
          auto-optimise-store = true;
          experimental-features = "nix-command flakes repl-flake";
          extra-sandbox-paths = ["/nix/var/cache/ccache"];
          max-jobs = "auto";
          substituters = [
            "https://nix-community.cachix.org"
            "https://willruggiano.cachix.org"
            "https://nixpkgs-wayland.cachix.org"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "willruggiano.cachix.org-1:rz00ME8/uQfWe+tN3njwK5vc7P8GLWu9qbAjjJbLoSw="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          ];
          trusted-users = ["root" "@wheel"];
        };
        gc = {
          automatic = true;
          dates = "weekly";
        };
      };
    };
  };
}
