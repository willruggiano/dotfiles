{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.browsing.qutebrowser;
in
{
  options.modules.browsing.qutebrowser = with types; {
    enable = mkBoolOpt false;
    dicts = mkOpt (listOf str) [ "en-US" ];
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      qutebrowser
      (makeDesktopItem {
        name = "qutebrowser-private";
        desktopName = "Qutebrowser (Private)";
        genericName = "Open a private Qutebrowser window";
        icon = "qutebrowser";
        exec = ''${qutebrowser}/bin/qutebrowser -T -s content.private_browsing true'';
        categories = "Network";
      })
      python39Packages.adblock
    ];

    home.configFile = {
      qutebrowser = {
        source = ../../.config/qutebrowser;
        recursive = true;
      };
    };

    environment.sessionVariables = {
      BROWSER = "qutebrowser";
    };

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
