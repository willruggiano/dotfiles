{pkgs, ...}: {
  imports = [
    ./builders.nix
    ./hardware-configuration.nix
    ./keyboard-layout.nix
    ./networking.nix
    ./security.nix
  ];

  networking.hostName = "mothership";
  nixpkgs.hostPlatform = "x86_64-linux";

  user = rec {
    name = "bombadil";
    initialPassword = name;
    home = "/home/${name}";
    shell = pkgs.fish;
  };

  location = {
    latitude = 37.7;
    longitude = -122.4;
  };

  programs = {
    brave.enable = true;
    brave.default = true;
    direnv.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git.enable = true;
    htop.enable = true;
    hyprland = {
      enable = true;
      extensions = {
        hypridle.enable = true;
        hyprlock = {
          enable = true;
          monitor = "eDP-1";
        };
      };
    };
    kitty.enable = true;
    pass.enable = true;
    # qutebrowser.enable = true;
    starship.enable = true;
  };

  services = {
    agenix.enable = true;
    darkman.enable = true;
    dropbox.enable = true;
    dunst.enable = true;
    kbfs.enable = true;
    passSecretService.enable = true;
    pcscd.enable = true;
    pipewire.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

  tendrel.enable = true;
  virtualisation.docker.enable = true;
}
