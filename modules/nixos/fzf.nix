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
        "--preview-window=right,border-sharp,wrap"
        "--bind='ctrl-p:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept'"
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
      environment.systemPackages = with pkgs; [
        (pkgs.buildEnv {
          name = "fzf-wrapped";
          buildInputs = [makeWrapper];
          paths = [fzf fzf.man];
          pathsToLink = [
            "/bin"
            "/share/man"
          ];
          postBuild = ''
            wrapProgram $out/bin/fzf --add-flags "${cfg.preview}"
          '';
        })
        bat
      ];

      environment.variables = {
        FZF_DEFAULT_COMMAND = cfg.command;
        FZF_DEFAULT_OPTS = toString cfg.options;
      };
    })
    (mkIf (cfg.enable && config.programs.fish.enable) {
      environment.systemPackages = with pkgs.fishPlugins; [fzf-fish];
      programs.fish.interactiveShellInit = mkBefore ''
        fzf_configure_bindings \
            --directory=\cf    \
            --git_log=\cg      \
            --git_status=      \
            --history=\cr      \
            --processes=\cp    \
            --variables=
      '';

      programs.flavours.items.fzf = {
        template = "${pkgs.base16-templates}/templates/fzf/templates/fish.mustache";
      };

      # home.configFile = {
      #   "fish/conf.d/base16-fzf.fish".source = config.programs.flavours.build.fzf;
      # };
    })
  ];
}
