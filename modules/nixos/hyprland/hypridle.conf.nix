{
  lib,
  pkgs,
  ...
}: let
  on-timeout = pkgs.writeShellApplication {
    name = "hypridle-on-timeout";
    runtimeInputs = with pkgs; [pipewire ripgrep systemd];
    text = ''
      pw-cli i all 2>&1 | rg running -q
      # only suspend when no active audio
      if [ $? == 1 ]; then
        systemctl suspend
      fi
    '';
  };
in ''
  general {
    before_sleep_cmd = ${pkgs.systemd}/bin/loginctl lock-session
    lock_cmd = ${lib.getExe pkgs.hyprlock}
  }

  listener {
    timeout = 300
    on-timeout = ${lib.getExe on-timeout}
  }
''
