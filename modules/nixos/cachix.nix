{
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.services.agenix.enable {
    environment.interactiveShellInit = ''
      export CACHIX_AUTH_TOKEN="$(cat ${config.age.secrets.cachix.path})"
    '';
  };
}
