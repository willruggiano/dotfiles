{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.zsh;
in {
  config = mkIf cfg.enable {
    programs.flavours.items.zsh = {
      file = "~/.config/zsh/extra/19-zsh-colors.zsh";
      template = "shell";
    };
  };
}
