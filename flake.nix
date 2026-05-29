{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
    } @ inputs:
    let
      user = "idan";
    in {
      nixosConfigurations = {
        rpi5 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          # specialArgs = { inherit inputs user; };
          modules = [
            inputs.disko.nixosModules.disko
            ./system.nix
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
