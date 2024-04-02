{
  withSystem,
  inputs,
  self,
  ...
}: {
  flake = {
    nixosConfigurations = {
      ecthelion = withSystem "x86_64-linux" (_:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs self;};
          modules = [
            self.nixosModules.default
            ./ecthelion
          ];
        });
      mothership = withSystem "x86_64-linux" (_:
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
