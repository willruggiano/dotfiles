{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./agenix.nix
    ./audio.nix
    ./autorandr-rs.nix
    ./backlight.nix
    ./blender.nix
    ./bluetooth.nix
    ./brave
    ./cachix.nix
    ./chromium.nix
    ./darkman.nix
    ./direnv.nix
    ./dropbox.nix
    ./dunst.nix
    ./email.nix
    ./expressvpn.nix
    ./firefox.nix
    ./fish
    ./fzf.nix
    ./git
    ./goxlr
    ./hyprland
    ./keybase.nix
    ./keyd.nix
    ./libreoffice.nix
    ./mopidy.nix
    ./nix.nix
    ./nvidia.nix
    ./obs.nix
    ./pipewire
    ./postgres.nix
    ./remarkable.nix
    ./shell.nix
    ./shpool
    ./spotify.nix
    ./ssh.nix
    ./starship.nix
    ./stylix.nix
    ./syncthing.nix
    ./trezor.nix
    ./utils.nix
    ./virtualisation.nix
    ./yubico.nix
  ];

  config = {
    programs = {
      brave.enable = true;
      brave.default = true;
      hyprland = {
        enable = true;
        extensions = {
          hypridle.enable = true;
          hyprlock.enable = true;
        };
      };
      kitty.enable = true;
      libreoffice.enable = true;
      pass.enable = true;
    };

    services = {
      agenix.enable = lib.mkDefault true;
      darkman.enable = lib.mkDefault true;
      dropbox.enable = lib.mkDefault true;
      dunst.enable = lib.mkDefault true;
      pcscd.enable = lib.mkDefault true;
      pipewire.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
      # tailscale.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };

    virtualisation.podman.enable = lib.mkDefault true;
  };
}
