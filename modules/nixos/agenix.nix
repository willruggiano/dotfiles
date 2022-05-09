{
  options,
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with builtins;
with lib; let
  inherit (inputs) agenix;
  cfg = config.services.agenix;
  shared_secrets = "${toString ../../secrets}";
  system_secrets = "${toString ../../secrets}/${config.networking.hostName}/secrets";
in {
  imports = [agenix.nixosModules.age];

  options.services.agenix = {
    enable = mkEnableOption "Enable agenix";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [agenix.defaultPackage.x86_64-linux];

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
          if pathExists "${system_secrets}/default.nix"
          then (mapSecrets system_secrets)
          else {}
        );
      sshKeyPaths =
        options.age.identityPaths.default
        ++ [
          "${config.user.home}/.ssh/id_ed25519"
        ];
    };
  };
}
