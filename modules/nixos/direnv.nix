{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.direnv;
in {
  options.programs.direnv.enable = mkEnableOption "direnv";

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.direnv];

    home.configFile = {
      "direnv/direnvrc".text = ''
        source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
      '';
    };

    programs.fish.interactiveShellInit = mkAfter ''
      ${pkgs.direnv}/bin/direnv hook fish | source
    '';
  };
}
