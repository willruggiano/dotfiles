{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.firefox;
in {
  options.programs.firefox = {
    enable = mkEnableOption "Enable firefox via homebrew";
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["firefox"];
    home.configFile."zsh/extra/99-firefox.zsh".text = ''
      alias firefox="/Applications/Firefox.app/Contents/MacOS/firefox-bin"
    '';
  };
}
