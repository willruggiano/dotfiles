{
  lib,
  pkgs,
  ...
}: ''
  general {
    before_sleep_cmd = ${pkgs.systemd}/bin/loginctl lock-session
    lock_cmd = ${lib.getExe pkgs.hyprlock}
  }

  listener {
    timeout = 300
  }
''
