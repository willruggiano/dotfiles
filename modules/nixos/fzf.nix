{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.fzf;
in {
  options.programs.fzf = {
    enable = mkEnableOption "fzf";
    command = mkOption {
      type = types.str;
      default = ''${pkgs.ripgrep}/bin/rg --files'';
      description = "FZF_DEFAULT_COMMAND";
    };

    options = mkOption {
      type = types.listOf types.str;
      default = [
        "--no-mouse"
        "--height 50%"
        "-1"
        "--reverse"
        "--multi"
        "--preview-window=right:wrap"
        "--bind='f3:execute(bat --style=numbers {} || less -f {}),ctrl-p:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept'"
      ];
      description = "FZF_DEFAULT_OPTS";
    };

    preview = mkOption {
      type = types.str;
      default = "--preview='bat --style=numbers --color=always {} 2>/dev/null'";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        (symlinkJoin {
          name = "fzf-wrapped";
          paths = [fzf];
          buildInputs = [makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/fzf --add-flags "${cfg.preview}"
          '';
        })
      ];

      environment.variables = {
        FZF_DEFAULT_COMMAND = cfg.command;
        FZF_DEFAULT_OPTS = toString cfg.options;
      };
    })
    (mkIf (cfg.enable && config.programs.fish.enable) {
      user.packages = with pkgs.fishPlugins; [fzf-fish];

      programs.flavours.items.fzf = {
        file = "~/.config/fish/conf.d/base16-fzf.fish";
        template = "fzf";
        subtemplate = "fish";
      };
    })
    (mkIf (cfg.enable && config.programs.zsh.enable) {
      programs.flavours.items.fzf = {
        file = "~/.config/zsh/extra/fzf-colors.zsh";
        template = "fzf";
      };
    })
  ];
}
