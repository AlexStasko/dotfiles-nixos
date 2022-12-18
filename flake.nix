{
  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, home-manager, nixpkgs, neovim-nightly }:
    let
      configNixos = import ./configuration/nixos;
      overlays = [ neovim-nightly.overlay ];
    in {
      nixosConfigurations = {
        vbox-personal = configNixos "astasko" {
          inherit nixpkgs home-manager overlays;
        };
      };
    };
}
