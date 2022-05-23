{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    fonts.fontDir.enable = true;
    fonts.fonts = with pkgs; [
      font-awesome
      # TODO: Why do I have both of these?
      jetbrains-mono
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      nonicons
    ];
  };
}
