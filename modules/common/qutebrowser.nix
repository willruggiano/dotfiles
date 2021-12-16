{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.qutebrowser;
in
{
  options.programs.qutebrowser = with types; {
    enable = mkEnableOption "Enable qutebrowser";
    default = mkEnableOption "Make qutebrowser the default browser";
    dicts = mkOption {
      type = listOf str;
      default = [ "en-US" ];
      description = ''
        TODO!
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
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
        "qutebrowser/userscripts/autorefresh" = {
          executable = true;
          text = ''
            #!${pkgs.python39}/bin/python

            import os
            import sys
            import time
            from pathlib import Path

            QUTE_COUNT = int(os.getenv("QUTE_COUNT", 30))
            QUTE_FIFO = os.environ["QUTE_FIFO"]
            QUTE_TAB = os.environ["QUTE_TAB"]

            command = f":run-with-count {QUTE_TAB} reload -f\n"

            lock = Path(f"~/.local/share/qutebrowser/autorefresh/{QUTE_TAB}").expanduser()
            with open(QUTE_FIFO, "w") as fifo:
              if lock.exists():
                # Then this call serves to "interrupt" a currently running userscript
                os.remove(lock)
                sys.exit(0)
              else:
                lock.parent.mkdir(parents=True, exist_ok=True)
                lock.touch()

              while lock.exists():
                fifo.write(command)
                fifo.flush()
                time.sleep(QUTE_COUNT)
          '';
        };
      };
    }
    # (mkIf (!pkgs.stdenv.isDarwin) {
    #   # Install language dictionaries for spellcheck backends
    #   system.userActivationScripts.qutebrowserInstallDicts =
    #     concatStringsSep "\\\n" (map
    #       (lang: ''
    #         if ! find "$HOME/.config/qutebrowser/qtwebengine_dictionaries" -type d -maxdepth 1 -name "${lang}*" 2>/dev/null | grep -q .; then
    #           ${pkgs.python3}/bin/python ${pkgs.qutebrowser}/share/qutebrowser/scripts/dictcli.py install ${lang}
    #         fi
    #       '')
    #       cfg.dicts);
    # })
    (mkIf cfg.default {
      environment.variables.BROWSER = "qutebrowser";
    })
  ]);
}
