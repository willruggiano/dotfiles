{
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.firefox.enable = true;
  programs.fzf.enable = true;
  programs.git = {
    enable = true;
    userName = "Will Ruggiano";
    userEmail = "wmruggiano@gmail.com";
  };
  programs.password-store.enable = true;
  programs.starship.enable = true;
  programs.zsh.enable = true;

  suites = {
    development.enable = true;
    development.suites = "all";
    file.enable = true;
  };
}