{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.docsets;
  filter-dasht-query = pkgs.writeShellApplication {
    name = "filter-dasht-query";
    runtimeInputs = [ pkgs.python310 ];
    text = ''
      COMMAND='${builtins.readFile ./filter-dasht-query-results.py}'
      python -c "''${COMMAND}"
    '';
  };
  app = pkgs.writeShellApplication {
    name = "K";
    runtimeInputs = [ filter-dasht-query pkgs.dasht pkgs.fzf pkgs.gawk ];
    # TODO: Do not open $BROWSER if abort
    text = ''
      dasht-query-line "$*" | filter-dasht-query | fzf --multi | awk '{ print $NF }' | xargs "$BROWSER"
    '';
  };
in
{
  options.programs.docsets = {
    enable = mkEnableOption "Enable docsets";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ docsets app ];
    environment.variables.DASHT_DOCSETS_DIR = "${pkgs.docsets}/share/docsets";
  };
}
