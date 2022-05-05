{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.dummy; # Installed via homebrew
  programs.fzf.enable = true;
  programs.git = {
    enable = true;
    userName = "Will Ruggiano";
    userEmail = "wruggian@amazon.com";
  };
  programs.htop.enable = true;
  programs.starship.enable = true;
  programs.zsh.enable = true;

  suites = {
    development.enable = true;
    development.suites = [
      "cxx"
      "json"
      "lua"
      "nix"
      "python"
      "shell"
    ];
    file.enable = true;
  };
}
