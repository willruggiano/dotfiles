{
  config,
  lib,
  ...
}: {
  config = {
    homebrew.casks = ["sublime-merge"];

    programs.colorctl.settings.lazygit.enable = true;
  };
}
