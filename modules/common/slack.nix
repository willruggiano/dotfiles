{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.slack;
  configfile = pkgs.writeTextFile {
    name = "slack-term-config";
    text = builtins.toJSON {
      notify = "mention";
      emoji = true;
    };
  };
in {
  options.programs.slack = {
    enable = mkEnableOption "Enable slack";
  };

  config = mkIf cfg.enable {
    user.packages = [
      (pkgs.runCommand ".slack-term-wrapped" {
        buildInputs = with pkgs; [makeWrapper];
      } ''
        mkdir $out
        ln -s ${pkgs.slack-term}/* $out
        rm $out/bin
        mkdir $out/bin
        makeWrapper ${pkgs.slack-term}/bin/slack-term $out/bin/slack \
          --add-flags "-config ${configfile}"                        \
          --add-flags "-token \"\$(cat ${config.age.secrets.slack.path})\""
      '')
    ];
  };
}
