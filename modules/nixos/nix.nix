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
      settings = let
        users = ["root" config.user.name];
      in {
        allowed-users = users;
        auto-optimise-store = mkDefault true;
        cores = mkDefault 0;
        substituters = [
          "https://nix-community.cachix.org"
          "https://willruggiano.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "willruggiano.cachix.org-1:rz00ME8/uQfWe+tN3njwK5vc7P8GLWu9qbAjjJbLoSw="
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
