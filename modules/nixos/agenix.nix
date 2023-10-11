{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  cfg = config.services.agenix;
  shared_secrets = "${toString ../../secrets}";
  system_secrets = "${toString ../../hosts}/${config.networking.hostName}/secrets";
in {
  imports = [inputs.agenix.nixosModules.default];

  options.services.agenix = {
    enable = mkEnableOption "Enable agenix";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages."${pkgs.system}".default
    ];

    age = {
      secrets = let
        mapSecrets = dir:
          mapAttrs'
          (n: _:
            nameValuePair (removeSuffix ".age" n) {
              file = "${dir}/${n}";
              owner = mkDefault config.user.name;
            })
          (import dir);
      in
        (mapSecrets shared_secrets)
        // (
          if pathExists system_secrets
          then (mapSecrets system_secrets)
          else {}
        );
    };
  };
}
