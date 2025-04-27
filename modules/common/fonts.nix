{pkgs, ...}: {
  config = {
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
      font-awesome
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      nonicons
    ];
  };
}
