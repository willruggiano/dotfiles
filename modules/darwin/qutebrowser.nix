{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.qutebrowser;
in
{
  options.programs.qutebrowser = {
    enable = mkEnableOption "Enable qutebrowser via homebrew";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [ "qutebrowser" ];
    home.configFile."zsh/extra/99-qutebrowser.zsh".text = ''
      alias qutebrowser="/Applications/qutebrowser.app/Contents/MacOS/qutebrowser"
    '';
  };
}
