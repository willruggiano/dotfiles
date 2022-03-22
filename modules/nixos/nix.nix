{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    nix = {
      settings = let users = [ "root" config.user.name ]; in
        {
          allowed-users = users;
          auto-optimise-store = mkDefault true;
          cores = mkDefault 0;
          substituters = [
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          trusted-users = users;
        };
      gc.dates = mkDefault "weekly";
    };

    user = {
      extraGroups = ["wheel"];
      isNormalUser = true;
      group = "users";
    };

    system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
    system.stateVersion = mkDefault "21.05";
  };
}
