{
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    signingkey = "0xB3FE328FB2A3ECD6";
    userName = "Will Ruggiano";
    userEmail = "wmruggiano@gmail.com";
  };
  programs.mpv.enable = true;
  programs.password-store.enable = true;

  services.dropbox.enable = true;
}
