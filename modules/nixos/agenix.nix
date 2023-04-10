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
  agenix-flake = inputs.agenix;
  cfg = config.services.agenix;
  shared_secrets = "${toString ../../secrets}";
  system_secrets = "${toString ../../secrets}/${config.networking.hostName}/secrets";
in {
  imports = [agenix-flake.nixosModules.age];

  options.services.agenix = {
    enable = mkEnableOption "Enable agenix";
  };

  config = mkIf cfg.enable {
    user.packages = let
      inherit (agenix-flake.packages."${pkgs.system}") agenix;
    in [
      (pkgs.writeShellApplication
        {
          name = "agenix";
          runtimeInputs = [agenix];
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
