{ config, lib, ... }:

with lib;
{
  config = {
    dotfiles.dir = "${config.user.home}/.config/darwin";

    nix = let users = [ "root" config.user.name ]; in
      {
        allowedUsers = users;
        binaryCaches = [
          "https://nix-community.cachix.org"
        ];
        binaryCachePublicKeys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        buildCores = 0;
        trustedUsers = users;
        gc.user = config.user.name;
      };

    system.stateVersion = 4;
  };
}
