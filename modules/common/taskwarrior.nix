{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.taskwarrior;
in
{
  options.programs.taskwarrior = {
    enable = mkEnableOption "taskwarrior";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ taskwarrior taskwarrior-tui ];

    home.configFile = {
      "taskwarrior/taskrc".text = ''
        # Generate by Nix
        data.location=~/.local/share/taskwarrior
      '';
    };

    environment.variables.TASKRC = "~/.config/taskwarrior/taskrc";
  };
}
