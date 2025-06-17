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
          "$hostname"
          "$directory"
          "$custom"
          "$line_break"
          "$username"
          "$character"
        ];
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](bold red)";
          vicmd_symbol = "[<](bold green)";
        };
        custom.tailscale = {
          command = "tailscale status --json | jq -r '.CurrentTailnet.Name'";
          when = "tailscale status";
          format = " \\($output\\)";
        };
        directory = {
          fish_style_pwd_dir_length = 1;
          style = "bold dimmed";
          truncate_to_repo = false;
          truncation_length = 2;
        };
        hostname.format = "[$hostname:](dimmed)";
        username.format = "$user";
      };
    };
  };
}
