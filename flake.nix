{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    {

      /*
        build with:
        nixos-rebuild build-image --flake '.#example' --image-variant google-compute
        or
        nix build '.#nixosConfigurations.example.config.system.build.imags.google-compute'
      */
      nixosConfigurations.example = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };

    };
}
