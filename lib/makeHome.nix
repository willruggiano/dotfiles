# vim: ft=nix
{ inputs, ... }:

path: { system, username, ... } @ attrs:
inputs.home-manager.lib.homeManagerConfiguration rec {
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
  extraModules = inputs.self.lib.mapModulesRec' ../modules/home import;
} // attrs
