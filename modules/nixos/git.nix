{pkgs, ...}: {
  config = {
    programs.flavours.items.lazygit = {
      file = "~/.config/lazygit/theme.yml";
      template = "custom/lazygit";
    };
  };
}
