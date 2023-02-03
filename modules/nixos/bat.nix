{pkgs, ...}: {
  config = {
    system.userActivationScripts.bat-theme = ''
      ${pkgs.bat}/bin/bat cache --clear && ${pkgs.bat}/bin/bat cache --build
    '';
  };
}
