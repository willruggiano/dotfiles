{
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.emanote.enable = true;
  programs.fzf.enable = true;
  programs.git = {
    enable = true;
    userName = "Will Ruggiano";
    userEmail = "wruggian@amazon.com";
  };
  programs.htop.enable = true;
  programs.neovim.enable = true;
  programs.starship.enable = true;
  programs.zsh.enable = true;

  suites = {
    aws.enable = true;
    development.enable = true;
    development.suites = "all";
    file.enable = true;
  };
}
