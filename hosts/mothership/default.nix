{
  config,
  pkgs,
  ...
}: {
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

    programs = {
      bat.enable = true;
      brave.enable = true;
      brave.default = true;
      direnv.enable = true;
      discord.enable = true;
      docsets.enable = true;
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
      pass.enable = true;
      qutebrowser.enable = true;
      slack.enable = true;
      sourcegraph.enable = true;
      spotify.enable = true;
      starship.enable = true;
      steam.enable = true;
      taskwarrior.enable = true;
      xplr.enable = true;
      zk.enable = true;
    };

    services = {
      agenix.enable = true;
      dunst.enable = true;
      kbfs.enable = true;
      pcscd.enable = true;
      pipewire.enable = true;
      postgresql = {
        enable = false;
        package = pkgs.postgresql;
        # The following creates a database and role of the same name as our system user.
        ensureDatabases = [config.user.name];
        ensureUsers = [
          {
            inherit (config.user) name;
            ensureClauses.superuser = true;
            # ensureDBOwnership = true;
          }
        ];
      };
      ssh.enable = true;
      tailscale.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };

    tendrel.enable = true;

    virtualisation.docker.enable = true;
  };
}
