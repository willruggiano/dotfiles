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

  programs = {
    bat.enable = true;
    brave.enable = true;
    brave.default = true;
    direnv.enable = true;
    discord.enable = true;
    # docsets.enable = true;
    fish.enable = true;
    fzf.enable = true;
    git = {
      enable = true;
      signingKey = "0x8C442553F8881E7A";
    };
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
    obs-studio.enable = true;
    pass.enable = true;
    qutebrowser.enable = true;
    slack.enable = true;
    sourcegraph.enable = true;
    spotify.enable = true;
    starship.enable = true;
    steam.enable = true;
    zk.enable = true;
  };

  services = {
    agenix.enable = true;
    darkman.enable = true;
    dropbox.enable = true;
    dunst.enable = true;
    kbfs.enable = true;
    pcscd.enable = true;
    pipewire.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

  tendrel.enable = true;
  virtualisation.docker.enable = true;
}
