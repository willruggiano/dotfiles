{
  lib,
  pkgs,
  ...
}: {
  config = {
    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        defaultFonts = {
          monospace = ["Iosevka Nerd Font Mono"];
          sansSerif = ["Iosevka Nerd Font"];
        };
        includeUserConf = lib.mkForce false;
      };
      packages = with pkgs; [
        iosevka
        nerd-fonts.iosevka
        # font-awesome
        # jetbrains-mono
        # nerd-fonts.jetbrains-mono
      ];
    };
  };
}
