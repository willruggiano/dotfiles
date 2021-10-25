# vim: ft=nix
{ inputs, ... }:

path: { system, username, ... } @ attrs:
let
  inherit (inputs.self.lib) reduceModulesRec;
in
inputs.home-manager.lib.homeManagerConfiguration ({
  inherit system username;
  stateVersion = "21.05";
  homeDirectory = "/home/${username}";
  configuration = {
    imports = [
      (path + "/home.nix")
    ];
  };
  pkgs = inputs.self.pkgs.${system}.nixpkgs;
  extraSpecialArgs = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  extraModules = reduceModulesRec ../modules/home import;
} // attrs)
