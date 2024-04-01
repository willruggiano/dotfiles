{
  withSystem,
  inputs,
  self,
  ...
}: {
  flake = {
    nixosConfigurations = {
      mothership = withSystem "x86_64-linux" ({inputs', ...}:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs self;};
          modules = [
            self.nixosModules.default
            ./mothership
          ];
        });
    };
  };
}
