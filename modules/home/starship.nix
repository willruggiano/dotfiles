{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.starship;
in {
  config = mkIf cfg.enable {
    programs.starship = {
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

        line_break = {
          disabled = false;
        };
      };
    };
  };
}
