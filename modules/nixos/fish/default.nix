{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.fish;

  eza-wrapped = pkgs.writeShellApplication {
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
    environment.systemPackages = with pkgs; [
      atuin
      eza
      magic-enter-fish
      zoxide
    ];

    programs.fish = {
      useBabelfish = true;

      interactiveShellInit = mkMerge [
        (mkBefore ''
          set -gx ATUIN_NOBIND true
          set -gx ENHANCD_FILTER fzf
          set -gx ENHANCD_DISABLE_DOT true
          set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS
          set -a _ZO_FZF_OPTS "--preview='${eza-wrapped}/bin/eza {2..}'"
          set -gx fish_greeting

          atuin init fish | source
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

          bind -M insert \r magic-enter
          bind -M insert \cr _atuin_search
          bind -M insert \cy accept-autosuggestion
          bind -M insert -k nul complete
        '')
      ];

      shellAliases = {
        bat = "bat --paging=never";
        batp = "bat --paging=auto";
        cat = "bat";
        grep = "rg --color=auto";
        ls = "eza -F";
        la = "eza -a";
        ll = "eza -l";
        lla = "eza -al";
        lt = "eza --tree";
        tree = "eza --tree";
      };
    };

    home.configFile = let
      toml = pkgs.formats.toml {};
    in {
      "atuin/config.toml".source = toml.generate "atuin-config" {
        update_check = false;
        search_mode = "fuzzy";
        filter_mode = "directory";
        workspaces = true;
      };

      "fish/functions" = {
        source = ./functions;
        recursive = true;
      };
    };
  };
}
