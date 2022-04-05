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
  secretsDir = "${toString ../../hosts}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [agenix.nixosModules.age];

  options.services.agenix = {
    enable = mkEnableOption "Enable agenix";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [agenix.defaultPackage.x86_64-linux];

    age = {
      secrets =
        if pathExists secretsFile
        then
          mapAttrs'
          (n: _:
            nameValuePair (removeSuffix ".age" n) {
              file = "${secretsDir}/${n}";
              owner = mkDefault config.user.name;
            })
          (import secretsFile)
        else {};
      sshKeyPaths =
        options.age.sshKeyPaths.default
        ++ [
          "${config.user.home}/.ssh/id_ed25519"
        ];
    };
  };
}
