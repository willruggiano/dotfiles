{pkgs, ...}: {
  imports = [
    ./builders.nix
    ./hardware-configuration.nix
    ./i18n.nix
    ./keyboard-layout.nix
    ./networking.nix
    ./security.nix
  ];

  config = {
    user = rec {
      name = "bombadil";
      initialPassword = name;
      home = "/home/${name}";
      shell = pkgs.fish;
    };

    programs.bat.enable = true;
    programs.brave.enable = true;
    programs.brave.default = true;
    programs.direnv.enable = true;
    programs.discord.enable = true;
    programs.docsets.enable = true;
    programs.flavours.enable = true;
    programs.fish.enable = true;
    programs.fzf.enable = true;
    programs.git = {
      enable = true;
      signingKey = "0x8C442553F8881E7A";
    };
    programs.htop.enable = true;
    programs.hyprland = {
      enable = true;
      wallpapers = {
        "eDP-1".source = ../../wallpapers/gandalf.jpg;
      };
    };
    programs.kitty.enable = true;
    programs.pass.enable = true;
    programs.qutebrowser.enable = true;
    programs.slack.enable = true;
    programs.sourcegraph.enable = true;
    programs.spotify.enable = true;
    programs.starship.enable = true;
    programs.steam.enable = true;
    programs.taskwarrior.enable = true;
    programs.xplr.enable = true;
    programs.zk.enable = true;

    services.agenix.enable = true;
    # services.dropbox.enable = true;
    services.dunst.enable = true;
    services.expressvpn.enable = true;
    services.kbfs.enable = true;
    services.pcscd.enable = true;
    services.pipewire.enable = true;
    services.ssh.enable = true;
    services.syncthing.enable = true;
    services.tailscale.enable = true;
    services.udev.packages = [pkgs.yubikey-personalization];

    tendrel.enable = true;

    virtualisation.docker.enable = true;
  };
}
