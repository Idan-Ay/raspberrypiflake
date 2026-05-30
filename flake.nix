{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    # nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-raspberrypi,
    ...
    } @ inputs:
    let
      user = "idan";
    in {
      nixosConfigurations = {
        rpi5 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs user nixos-raspberrypi; };
          modules = [
            inputs.disko.nixosModules.disko
            ./system.nix
            .hardware-configuration.nix
          ];
        };
      };

      homeConfigurations = {
        rpi5 = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [
            ./home.nix
          ];
          # extraSpecialArgs = { inherit inputs user; };
        };
      };
    };
}
