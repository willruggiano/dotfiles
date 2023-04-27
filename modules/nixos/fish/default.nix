{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.fish;

  exa-wrapped = pkgs.writeShellApplication {
    name = "exa";
    runtimeInputs = with pkgs; [exa];
    text = ''
      pushd "$1" >/dev/null
      exa --tree --git-ignore
      popd >/dev/null
    '';
  };

  pass-completions = pkgs.stdenv.mkDerivation {
    name = "pass-fish-completions";

    inherit (pkgs.pass) src;

    nativeBuildInputs = with pkgs; [installShellFiles];

    dontBuild = true;
    dontConfigure = true;
    dontFixup = true;

    installPhase = ''
      installManPage man/pass.1
      installShellCompletion --fish --name pass.fish src/completion/pass.fish-completion
    '';
  };
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      atuin
      exa
      magic-enter-fish
      pass-completions
      starship
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
          set -a _ZO_FZF_OPTS "--preview='${exa-wrapped}/bin/exa {2..}'"
          set -gx fish_escape_delay_ms 300
          set -gx fish_greeting

          atuin init fish | source
          zoxide init fish | source
        '')
        (mkAfter ''
          fish_vi_key_bindings insert
          bind -M insert \r magic-enter
          bind -M insert \co 'fzf | xargs -r $EDITOR'
          bind -M insert \cr _atuin_search
          bind -M insert \cy accept-autosuggestion
          bind -M insert -k nul complete
        '')
      ];

      shellAliases = {
        bat = "bat --paging=never";
        batp = "bat --paging=auto";
        cat = "bat";
        fvim = "nvim $(fzf)";
        nvim-clear = "nvim --headless -c LuaCacheClear -c q && nvim";
        grep = "rg --color=auto";
        ls = "exa -F";
        la = "exa -a";
        ll = "exa -l";
        lla = "exa -al";
        lt = "exa --tree";
        tree = "exa --tree";
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        format = concatStrings [
          "$hostname"
          "$line_break"
          "$directory"
          "$git_branch"
          "$nix_shell"
          "$python"
          "$line_break"
          "$character"
        ];
        right_format = concatStrings [
          "$time"
          "$line_break"
        ];
        scan_timeout = 30;
        command_timeout = 500;
        add_newline = true;

        character = {
          disabled = false;
          format = "$symbol ";
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vicmd_symbol = "[❮](bold green)";
        };

        directory = {
          disabled = false;
          truncation_length = 3;
          truncate_to_repo = true;
          fish_style_pwd_dir_length = 0;
          use_logical_path = true;
          format = "[$path]($style)[$read_only]($read_only_style) ";
          style = "cyan bold";
          read_only = "🔒";
          read_only_style = "red";
          truncation_symbol = "";
          home_symbol = "~";
        };

        git_branch = {
          disabled = false;
          format = "on [$symbol$branch]($style)(:[$remote]($style)) ";
          style = "bold purple";
          symbol = "";
          truncation_length = 9223372036854775807;
          truncation_symbol = "...";
          only_attached = false;
          always_show_remote = false;
        };

        hostname = {
          ssh_only = true;
          format = concatStrings [
            "[$hostname](bold red)"
          ];
        };

        nix_shell = {
          format = "using [nix-shell/$name](bold blue) ";
        };

        python = {
          format = "using [python/$version (\($virtualenv\))](bold yellow) ";
        };

        time = {
          disabled = false;
          format = "[$time]($style)";
        };

        line_break = {
          disabled = false;
        };
      };
    };

    home.configFile = let
      toml = pkgs.formats.toml {};
    in {
      "atuin/config.toml".source = toml.generate "atuin-config" {
        update_check = false;
        search_mode = "fuzzy";
        filter_mode = "directory";
      };

      "fish/functions" = {
        source = ./functions;
        recursive = true;
      };
    };
  };
}
