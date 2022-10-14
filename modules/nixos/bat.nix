{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    programs.colorctl.settings = {
      bat = {
        enable = true;
        reload-command = let
          cmd = pkgs.writeShellApplication {
            name = "reload-bat-theme";
            runtimeInputs = with pkgs; [bat];
            text = ''
              bat cache --clear && bat cache --build
            '';
          };
        in "${cmd}/bin/reload-bat-theme";
      };
    };
  };
}
