{pkgs, ...}: {
  config = {
    programs.colorctl.settings.lazygit.reload = true;
  };
}
