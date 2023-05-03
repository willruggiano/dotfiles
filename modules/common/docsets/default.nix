{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.docsets;
in {
  options.programs.docsets = {
    enable = mkEnableOption "Enable docsets";
  };

  config = mkIf cfg.enable {
    environment.variables.DASHT_DOCSETS_DIR = "${pkgs.docsets}/share/docsets";
  };
}
