{ inputs, config, lib, pkgs, ... }:

with lib;
{
  config = {
    nix = {
      autoOptimiseStore = mkDefault true;
      gc.dates = mkDefault "weekly";
    };

    user = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      group = "users";
    };

    system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
    system.stateVersion = mkDefault "21.05";
  };
}
