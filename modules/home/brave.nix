{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.brave;
in {
  config = mkIf cfg.enable {
    programs.brave = {
      extensions = [
        # Sourcegraph
        {id = "dgjhfomjieaadpoljlnidmbgkdffpack";}
        # uBlock Origin
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
        # Vimium
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";}
      ];
    };
  };
}
