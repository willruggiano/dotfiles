{
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    signingkey = "0x8C442553F8881E7A";
    userName = "Will Ruggiano";
    userEmail = "wmruggiano@gmail.com";
  };
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
