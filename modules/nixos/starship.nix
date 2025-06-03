{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.starship;
in {
  config = mkIf cfg.enable {
    programs.starship = {
      settings = {
        format = concatStrings [
          "$username"
          "@"
          "$hostname"
          ":"
          "$directory"
          "$git_branch"
          "$nix_shell"
          "$python"
          "$custom"
          "$line_break"
          "$character"
        ];
        add_newline = true;

        character = {
          success_symbol = "[\\$](bold green)";
          error_symbol = "[\\$](bold red)";
          vicmd_symbol = "[>](bold green)";
        };

        custom.tailscale = {
          command = "tailscale status --json | jq -r '.CurrentTailnet.Name'";
          when = "tailscale status";
          format = "\\($output\\)";
        };

        directory = {
          truncation_length = 2;
          truncate_to_repo = false;
          fish_style_pwd_dir_length = 1;
        };

        git_branch.format = "on [$branch(:$remote_branch)]($style) ";

        hostname = {
          ssh_only = false;
          format = "[$hostname](bold dimmed)";
        };

        nix_shell.format = "using [nix-shell/$name](bold blue) ";
        python.format = "using [python/$version (\($virtualenv\))](bold yellow) ";
        username = {
          format = "[$user]($style)";
          style_user = "bold dimmed";
        };
      };
    };
  };
}
