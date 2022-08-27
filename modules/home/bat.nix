{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.bat;
in {
  config = mkIf cfg.enable {
    programs.bat.config = {
      map-syntax = "*.tpp:C++";
      theme = "awesome";
    };
  };
}
