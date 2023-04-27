{
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.htop.enable = true;
  programs.mpv.enable = true;
  programs.password-store.enable = true;
  programs.starship.enable = true;

  services.dropbox.enable = true;
  # services.emanote.enable = true;
  services.kbfs.enable = true;

  suites = {
    development.enable = true;
    development.suites = "all";
    file.enable = true;
  };
}
