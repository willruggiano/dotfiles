{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.qutebrowser;
in
{
  options.programs.qutebrowser = with types; {
    enable = mkEnableOption "Enable qutebrowser";
    dicts = mkOption {
      type = listOf str;
      default = [ "en-US" ];
    };

  };

  config = mkIf (cfg.enable && pkgs.stdenv.isLinux) {
    user.packages = with pkgs;
      [
        qutebrowser
        (writeShellApplication {
          name = "qutebrowser-private";
          runtimeInputs = [ qutebrowser ];
          text = ''
            qutebrowser -T -s content.private_browsing true
          '';
        })
        (makeDesktopItem {
          name = "qutebrowser-private";
          desktopName = "Qutebrowser (Private)";
          genericName = "Open a private Qutebrowser window";
          icon = "qutebrowser";
          exec = ''${qutebrowser}/bin/qutebrowser -T -s content.private_browsing true'';
          categories = "Network";
        })
      ];

    # Install language dictionaries for spellcheck backends
    system.userActivationScripts.qutebrowserInstallDicts =
      concatStringsSep "\\\n" (map
        (lang: ''
          if ! find "$HOME/.config/qutebrowser/qtwebengine_dictionaries" -type d -maxdepth 1 -name "${lang}*" 2>/dev/null | grep -q .; then
            ${pkgs.python3}/bin/python ${pkgs.qutebrowser}/share/qutebrowser/scripts/dictcli.py install ${lang}
          fi
        '')
        cfg.dicts);
  };
}