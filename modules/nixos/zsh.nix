{pkgs, ...}: {
  config = {
    programs.flavours.items.zsh = {
      file = "~/.config/zsh/extra/19-zsh-colors.zsh";
      template = "shell";
    };

    # home.configFile = {
    #   "zsh/extra/19-zsh-colors.sh".text = ''
    #     ${pkgs.base16-templates}/
    #   '';
    # };
  };
}
