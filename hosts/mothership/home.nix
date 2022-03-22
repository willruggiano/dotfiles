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
  programs.htop.enable = true;
  # programs.neovim.enable = true;
  programs.password-store.enable = true;
  programs.starship.enable = true;
  programs.zsh.enable = true;

  services.dropbox.enable = true;
  # services.emanote.enable = true;
  services.kbfs.enable = true;

  suites = {
    aws.enable = true;
    development.enable = true;
    development.suites = "all";
    file.enable = true;
  };
}
