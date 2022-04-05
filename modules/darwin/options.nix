{
  options,
  config,
  lib,
  darwin,
  ...
}:
with lib; {
  config = {
    dotfiles.dir = "${config.user.home}/.config/darwin";

    nix = {
      gc.user = config.user.name;
    };

    system.stateVersion = 4;
  };
}
