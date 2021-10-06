{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;

let
  sys = "x86_64-linux";
in
{
  mkSystem = path: attrs @ { system ? sys, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
          nixpkgs.pkgs = pkgs;
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ../. # /default.nix
        (import path)
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.users.bombadil = import "${path}/home"; # Maybe give this a try?
          home-manager.users.bombadil = import ../home;
        }
      ];
    };

  mapSystems = dir: attrs @ { system ? system, ... }:
    mapModules dir
      (path: mkSystem path attrs);
}
