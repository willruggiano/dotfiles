{pkgs, ...}: {
  config = {
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
      font-awesome
      jetbrains-mono
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      nonicons
    ];
  };
}
