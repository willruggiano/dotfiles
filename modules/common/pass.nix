{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.pass;
  pass-completions = pkgs.stdenv.mkDerivation {
    name = "pass-fish-completions";

    inherit (pkgs.pass) src;

    nativeBuildInputs = with pkgs; [installShellFiles];

    dontBuild = true;
    dontConfigure = true;
    dontFixup = true;

    installPhase = ''
      installManPage man/pass.1
      installShellCompletion --fish --name pass.fish src/completion/pass.fish-completion
    '';
  };
in {
  options.programs.pass = {
    enable = mkEnableOption "password-store";
    secret-service.enable = mkEnableOption "pass-secret-service";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.browserpass.enable = true;
      environment.systemPackages = with pkgs; [
        (writeShellApplication {
          name = "pass";
          runtimeInputs = [
            coreutils
            fd
            fzf
            gnused
            (pass.withExtensions (es:
              with es; [
                pass-extension-clip
                pass-extension-meta
                pass-update
              ]))
          ];
          text = ''
            if (( $# > 0 )); then
              pass "$@"
            else
              pushd "$PASSWORD_STORE_DIR" >/dev/null
              passfile=$(fd -e gpg --strip-cwd-prefix . | sed -e 's/.gpg$//' | sort | fzf)
              pass --clip "$passfile"
              unset passfile
              popd
            fi
          '';
        })
        pass-completions
      ];

      environment.variables.PASSWORD_STORE_DIR = "${config.user.home}/.password-store";
    }
    (mkIf cfg.secret-service.enable {
      services.passSecretService.enable = true;
    })
  ]);
}
