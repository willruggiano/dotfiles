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

  nix.settings.max-jobs = 24;

  programs = {
    hyprland.extensions.hyprlock.monitor = "DP-2";
    obs-studio.enable = true;
    steam.enable = true;
  };

  services = {
    autorandrd = {
      enable = true;
      config = ./monitor-layout.kdl;
    };
    remarkable.enable = true;
  };
}
