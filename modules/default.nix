{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules.default = {
      config,
      lib,
      pkgs,
      ...
    }: {
      imports = [
        {
          _module.args = {
            pkgs' = import inputs.nixpkgs-latest {
              inherit (config.nixpkgs) config;
              inherit (pkgs.stdenv.hostPlatform) system;
            };
          };
        }
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
        # TODO: these are leftover from the aws darwin days, and we ain't never
        # goin back there lmao
        ./common
        ./nixos
      ];

      config = {
        nixpkgs = {
          config = {
            allowBroken = true;
            allowUnfreePredicate = pkg:
              builtins.elem (lib.getName pkg) [
                "steam"
                "steam-unwrapped"
                "sublime-merge"
                # nvidia
                "cuda-merged"
                "cuda_cccl"
                "cuda_cudart"
                "cuda_cuobjdump"
                "cuda_cupti"
                "cuda_cuxxfilt"
                "cuda_nvml_dev"
                "cuda_nvrtc"
                "cuda_nvtx"
                "cuda_gdb"
                "cuda_nvcc"
                "cuda_nvdisasm"
                "cuda_nvprune"
                "cuda_profiler_api"
                "cuda_sanitizer_api"
                "libcufft"
                "libcublas"
                "libcurand"
                "libcusolver"
                "libcusparse"
                "libnvjitlink"
                "libnpp"
                "nvidia-settings"
                "nvidia-x11"
              ];
          };
          overlays = [
            self.overlays.default
            inputs.hypr.overlays.default
            inputs.jj.overlays.default
            inputs.jj-gh.overlays.default
            inputs.nur.overlays.default
          ];
        };

        nix = {
          registry = {
            nixpkgs.flake = inputs.nixpkgs;
            nixpkgs-latest.flake = inputs.nixpkgs-latest;
          };
          settings = {
            auto-optimise-store = true;
            experimental-features = ["nix-command" "flakes"];
            extra-sandbox-paths = ["/nix/var/cache/ccache"];
            nix-path = [
              "nixpkgs=${inputs.nixpkgs}"
              "nixpkgs-latest=${inputs.nixpkgs-latest}"
            ];
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
