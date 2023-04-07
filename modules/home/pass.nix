{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.password-store;
  PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
  pass-fzf = pkgs.writeShellApplication {
    name = "pass";
    runtimeInputs = with pkgs; [
      coreutils
      fd
      fzf
      gnused
      xclip
      (pass.withExtensions (exts:
        with exts; [
          pass-extension-clip
          pass-extension-meta
          pass-update
        ]))
    ];
    text = ''
      if (( $# > 0 )); then
        pass "$@"
      else
        pushd "${PASSWORD_STORE_DIR}" >/dev/null
        passfile=$(fd -e gpg --strip-cwd-prefix . | sed -e 's/.gpg$//' | sort | fzf)
        pass --clip "$passfile"
        unset passfile
        popd
      fi
    '';
  };
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cryptsetup
      paperkey
      yubikey-manager
    ];

    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = false;
      pinentryFlavor = "gtk2";
    };

    programs.password-store = {
      package = pass-fzf;
      settings = {
        inherit PASSWORD_STORE_DIR;
      };
    };
  };
}
