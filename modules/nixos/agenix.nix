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
  cfg = config.services.agenix;
  shared_secrets = "${toString ../../secrets}";
  system_secrets = "${toString ../../secrets}/${config.networking.hostName}/secrets";
in {
  imports = [inputs.agenix.nixosModules.default];

  options.services.agenix = {
    enable = mkEnableOption "Enable agenix";
  };

  config = mkIf cfg.enable {
    user.packages = [
      (pkgs.writeShellApplication
        {
          name = "agenix";
          runtimeInputs = [inputs.agenix.packages."${pkgs.system}".default];
          text = ''
            pushd ${config.dotfiles.dir}/secrets 1>/dev/null
            RULES="./default.nix" agenix "$@"
            popd 1>/dev/null
          '';
        })
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
          if pathExists "${system_secrets}/default.nix"
          then (mapSecrets system_secrets)
          else {}
        );
      identityPaths =
        options.age.identityPaths.default
        ++ [
          "${config.user.home}/.ssh/id_ed25519"
        ];
    };
  };
}
