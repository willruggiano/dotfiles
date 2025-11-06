install:
    nixos-rebuild switch --sudo
    notify-send --transient 'nixos be ready'

no-builders:
    nixos-rebuild switch --sudo --builders ""
    notify-send --transient 'nixos be ready'

boot:
    nixos-rebuild boot --sudo

build:
    nixos-rebuild build |& nom

clean:
    nix-collect-garbage -d
    sudo nix-collect-garbage -d
