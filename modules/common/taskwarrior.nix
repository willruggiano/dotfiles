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
      "task/taskrc".text = ''
        # Generate by Nix
        data.location=$XDG_DATA_HOME/task
      '';
    };
  };
}
