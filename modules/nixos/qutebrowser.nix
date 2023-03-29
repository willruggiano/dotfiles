{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.qutebrowser;
in {
  options.programs.qutebrowser = with types; {
    enable = mkEnableOption "Enable qutebrowser";
    package = mkPackageOption pkgs "qutebrowser" {};
    dicts = mkOption {
      type = listOf str;
      default = ["en-US"];
    };
  };

  config = mkIf cfg.enable {
    user.packages = [cfg.package];

    # Install language dictionaries for spellcheck backends
    # TODO: Re-enable this when a new release is created; see: https://github.com/qutebrowser/qutebrowser/issues/7481
    # system.userActivationScripts.qutebrowserInstallDicts = concatStringsSep "\\\n" (map
    # (lang: ''
    #   if ! find "$HOME/.config/qutebrowser/qtwebengine_dictionaries" -type d -maxdepth 1 -name "${lang}*" 2>/dev/null | grep -q .; then
    #     ${pkgs.python3}/bin/python ${pkgs.qutebrowser}/share/qutebrowser/scripts/dictcli.py install ${lang}
    #   fi
    # '')
    # cfg.dicts);
  };
}
