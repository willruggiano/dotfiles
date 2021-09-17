{ options, config, pkgs, lib, ... }:

with lib;
with lib.my;

let cfg = config.modules.services.gpg;
in
{
  options.modules.services.gpg = {
    enable = mkBoolOpt false;
    enablePass = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        paperkey
        pinentry-curses
        yubikey-manager
      ];

      services.udev.packages = [ pkgs.yubikey-personalization ];

      environment.shellInit = ''
        export GPG_TTY="$(tty)"
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      '';

      programs = {
        ssh.startAgent = false;
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
          pinentryFlavor = "curses";
        };
      };

      services.pcscd.enable = true;
    })

    (mkIf (cfg.enable && cfg.enablePass) {
      user.packages = with pkgs; [
        pass.withExtensions
        (exts: [ exts.pass-audit exts.pass-update ])
      ];
    })
  ];
}
