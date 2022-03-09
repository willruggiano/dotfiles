{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.qutebrowser;
in
{
  options.programs.qutebrowser = with types; {
    default = mkEnableOption "Make qutebrowser the default browser";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
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
            from urllib.parse import urlparse

            QUTE_COUNT = int(os.getenv("QUTE_COUNT", 30))
            QUTE_FIFO = os.environ["QUTE_FIFO"]
            QUTE_TAB = os.environ["QUTE_TAB_INDEX"]
            QUTE_URL = os.environ["QUTE_URL"]

            command = f":run-with-count {QUTE_TAB} reload -f\n"

            domain = urlparse(f"{QUTE_URL}").netloc
            lock = Path(f"~/.cache/qutebrowser/autorefresh/{domain}").expanduser()
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
    (mkIf cfg.default {
      environment.variables.BROWSER = "qutebrowser";
    })
  ]);
}
