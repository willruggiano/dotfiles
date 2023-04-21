{config, ...}: {
  security.pam.yubico.enable = true;
  security.sudo.extraRules = [
    {
      users = [config.user.name];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nmcli";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nmtui";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
