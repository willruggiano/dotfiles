{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./keyboard-layout.nix
    ./networking.nix
    ./security.nix
  ];

  networking.hostName = "ecthelion";
  nixpkgs.hostPlatform = "x86_64-linux";
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

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
    bat.enable = true;
    brave.enable = true;
    brave.default = true;
    browserpass.enable = true;
    direnv.enable = true;
    discord.enable = true;
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
          monitor = "DP-2";
        };
      };
    };
    kitty.enable = true;
    obs-studio.enable = true;
    pass.enable = true;
    # qutebrowser.enable = true;
    # qutebrowser.default = true;
    slack.enable = true;
    # sourcegraph.enable = true;
    spotify.enable = true;
    starship.enable = true;
    steam.enable = true;
    zk.enable = true;
  };

  services = {
    agenix.enable = true;
    autorandrd = {
      enable = true;
      config = ./monitor-layout.kdl;
    };
    darkman.enable = true;
    dropbox.enable = true;
    dunst.enable = true;
    kbfs.enable = true;
    pcscd.enable = true;
    pipewire.enable = true;
    remarkable.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
    trezord.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

  tendrel.enable = true;
  virtualisation.docker.enable = true;
}
