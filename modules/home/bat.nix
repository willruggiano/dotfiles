{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.bat;
  colorscheme = "tomorrow-night-eighties";

  theme = pkgs.runCommandLocal "bat-theme" {buildInputs = [pkgs.flavours];} ''
    flavours build "${pkgs.base16-schemes}/${colorscheme}.yaml" "${pkgs.base16-templates}/templates/textmate/templates/default.mustache" > $out
  '';
in {
  config = mkIf cfg.enable {
    programs.bat = {
      config = {
        map-syntax = "*.tpp:C++";
        theme = colorscheme;
      };
      themes = {
        "${colorscheme}" = builtins.readFile theme;
      };
    };
  };
}
