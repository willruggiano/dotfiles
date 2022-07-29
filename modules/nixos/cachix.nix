{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.services.agenix.enable {
    home.configFile = {
      "zsh/extra/19-cachix.zsh".text = ''
        export CACHIX_AUTH_TOKEN="$(cat ${config.age.secrets.cachix.path})"
      '';
    };
  };
}
