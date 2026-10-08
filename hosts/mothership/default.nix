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

  fonts.fontSize = 10;

  programs = {
    hyprland.extensions.hyprlock.monitor = "eDP-1";
  };
}
