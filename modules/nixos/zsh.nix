{pkgs, ...}: {
  config = {
    programs.flavours.items.zsh = {
      file = "~/.config/zsh/extra/19-zsh-colors.zsh";
      template = "shell";
    };
  };
}
