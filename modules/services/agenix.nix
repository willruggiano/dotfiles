{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let
  inherit (inputs) agenix;
  cfg = config.modules.services.agenix;
  secretsDir = "${toString ../nixos/configurations}/${config.networking.hostName}/secrets";
  secretsFile = "${secretsDir}/secrets.nix";
in
{
  imports = [ agenix.nixosModules.age ];

  options.modules.services.agenix = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

    age = {
      secrets =
        if pathExists secretsFile
        then
          mapAttrs'
            (n: _: nameValuePair (removeSuffix ".age" n) {
              file = "${secretsDir}/${n}";
              owner = mkDefault config.user.name;
            })
            (import secretsFile)
        else { };
      sshKeyPaths =
        options.age.sshKeyPaths.default ++ (filter pathExists [
          "${config.user.home}/.ssh/id_ed25519"
          "${config.user.home}/.ssh/id_rsa"
        ]);
    };
  };
}
