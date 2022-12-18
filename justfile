clean:
    rm -f ./result

vbox command: && clean
    sudo nixos-rebuild {{ command }} --flake ".#vbox-personal"

update:
    nix flake update
    niv update
