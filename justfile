install:
    nixos-rebuild switch --use-remote-sudo
    notify-send --transient 'nixos be ready'

build:
    nixos-rebuild build |& nom

garbage:
    nix-collect-garbage -d
    sudo nix-collect-garbage -d
