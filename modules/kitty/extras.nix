{ config, lib, pkgs }:

with lib;

let
  cfg = config.programs.kitty.extras;
in {
  options.programs.kitty.extras = {
    useSymbolsFromNerdFont = mkOption {
      type = types.str;
      default = "";
      example = "JetBrainsMono Nerd Font";
      description = ''
        NerdFont patched fonts frequently suffer from rendering issues in terminals. To mitigate
        this, we can use a non-NerdFont with Kitty and use the <literal>symbol_map</literal> setting
        to tell Kitty to only use a NerdFont for NerdFont symbols.
        Set this option the name of an installed NerdFont (the same name you'd use in the
        <literal>font_family</literal> setting), to enable this feature.
      '';
    };
  };
};

config = mkIf config.programs.kitty.enable {
  programs.kitty.settings = {} // optionalAttrs (cfg.useSymbolsFromNerdFont != "") {
    # https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
    symbol_map = "U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26a1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D ${cfg.useSymbolsFromNerdFont}";
  };
}
