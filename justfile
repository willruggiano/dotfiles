apply:
    nixos apply --local-root
    notify-send --transient 'nixos be ready'

clean:
    nix-collect-garbage -d
    sudo nix-collect-garbage -d
