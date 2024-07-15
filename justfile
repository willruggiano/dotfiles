install:
    nixos-rebuild switch --use-remote-sudo
    notify-send --transient 'nixos be ready'

boot:
    nixos-rebuild boot --use-remote-sudo

build:
    nixos-rebuild build |& nom

clean:
    nix-collect-garbage -d
    sudo nix-collect-garbage -d
