{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.password-store;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cryptsetup
      paperkey
      yubikey-manager
    ];

    programs.gpg.enable = true;
    programs.ssh.enable = false;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryFlavor = "gtk2";
    };

    programs.password-store = {
      package = pkgs.pass.withExtensions (exts: [pkgs.pass-extension-meta exts.pass-update]);
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
      };
    };
  };
}
