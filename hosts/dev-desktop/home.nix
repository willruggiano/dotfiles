{
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.direnv.enable = true;
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

  suites.extras = {
    awscli.enable = true;
    curl.enable = true;
    fd.enable = true;
    file.enable = true;
    qrcp.enable = true;
    ranger.enable = true;
    ripgrep.enable = true;
    thefuck.enable = true;
    trash-cli.enable = true;
    unzip.enable = true;
    wget.enable = true;
    xplr.enable = true;
  };

  suites.development = {
    enable = true;
    suites = "all";
  };
}
