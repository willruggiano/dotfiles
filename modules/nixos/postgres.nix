{
  config,
  lib,
  pkgs',
  ...
}: let
  cfg = config.services.postgresql;
in {
  config = lib.mkIf cfg.enable {
    services.postgresql = {
      package = pkgs'.postgresql_18;
      authentication = lib.mkOverride 10 ''
        #type database  user    auth-method
        local all       all     trust
      '';
    };
    systemd.targets.postgresql.wantedBy = lib.mkForce [];
  };
}
