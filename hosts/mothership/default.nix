{ pkgs, config, lib, ... }:

with lib;
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  users.users.bombadil = {
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    home = "/home/bombadil";
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;
  };

  networking.hostName = "mothership";
  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  age = {
    secrets = {
      github.file = ./secrets/github.age;
      github.owner = "bombadil";
    };
    sshKeyPaths = [
      "/home/bombadil/.ssh/id_ed25519"
    ];
  };

  environment.systemPackages = [
    pkgs.agenix
  ];

  fonts = {
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      (pkgs.callPackage ./fonts.nix { })
      fira-code
      fira-code-symbols
      iosevka
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  services = {
    keybase.enable = true;

    kbfs = {
      enable = true;
      mountPoint = "%h/.local/keybase";
    };

    pcscd.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "ctrl:nocaps";
      libinput.touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
        tapping = false;
      };
      desktopManager.xterm.enable = false;
      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;
        autoLogin = {
          enable = true;
          user = "bombadil";
        };
      };
      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
          extraPackages = with pkgs; [
            dmenu
            font-awesome
            i3status-rust
            i3lock
            rofi
          ];
        };
      };
    };
  };

  system.stateVersion = "21.05";
}
