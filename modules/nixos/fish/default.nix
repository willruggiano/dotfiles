{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.fish;

  zo-fzf-previewer = pkgs.writeShellApplication {
    name = "eza";
    runtimeInputs = with pkgs; [eza];
    text = ''
      pushd "$1" >/dev/null
      eza --tree --git-ignore
      popd >/dev/null
    '';
  };
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [eza zoxide];

    programs.fish = {
      useBabelfish = true;

      interactiveShellInit = mkMerge [
        (mkBefore ''
          set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS
          set -a _ZO_FZF_OPTS "--preview='${zo-fzf-previewer}/bin/eza {2..}'"
          set -gx fish_greeting
          zoxide init fish | source
        '')
        (mkAfter ''
          fish_vi_key_bindings insert
          bind -M insert \ca beginning-of-line
          bind -M insert \ce end-of-line
          set fish_cursor_default block blink
          set fish_cursor_insert line blink
          set fish_cursor_replace_one underscore
          set fish_cursor_visual block
          set fish_escape_delay_ms 300
          bind \r magic-enter
          bind -M insert \r magic-enter
          bind -M insert \cy accept-autosuggestion
          bind -M insert -k nul complete
        '')
      ];

      shellAliases = {
        bat = "bat -pp";
        ls = "eza -F -l";
        vim = "nvim";
      };
    };

    home.configFile = {
      "fish/functions" = {
        source = ./functions;
        recursive = true;
      };
    };
  };
}
