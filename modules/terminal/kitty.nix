{ options, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.terminal.kitty;
  defaultFont = {
    name = "JetBrains Mono";
    package = pkgs.jetbrains-mono;
    size = 12;
  };
in
{
  options.modules.terminal.kitty = {
    enable = mkEnableOption "Enable kitty";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ kitty ];

    fonts.fonts = with pkgs; [
      defaultFont.package
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    home.configFile = {
      kitty = {
        source = ../../.config/kitty;
        recursive = true;
      };

      "kitty/kitty.conf".text =
        let
          hint = "kitten hints --alphabet asdfghjkl";
        in
        ''
          # Generated by Nix

          font_family ${defaultFont.name}
          font_size ${toString defaultFont.size}
          include theme.conf

          disable_ligatures always
          enable_audio_bell no
          sync_to_monitor no

          symbol_map U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26a1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D JetBrainsMono Nerd Font
          symbol_map U+F101-U+F208 nonicons

          open_url_with ${pkgs.qutebrowser}/bin/qutebrowser

          # Trying to make these similar to qutebrowser mappings
          # ;e hint links edit
          map ctrl+semicolon>e ${hint} --type hyperlink
          # ;m hint matches
          map ctrl+semicolon>m ${hint} --type linenum nvim +{line} {path}
          # ;o hint urls open
          map ctrl+semicolon>o open_url_with_hints
          # ;y hint paths yank
          map ctrl+semicolon>y ${hint} --type path --program -
        '';
    };
  };
}
