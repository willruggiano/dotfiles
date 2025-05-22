{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.email;
in {
  options.services.email = {
    enable = mkEnableOption "email";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      himalaya
      neverest
      notmuch
    ];

    home.configFile = {
    };

    home.file = {
      # "mail/.notmuch/hooks/pre-new" = {
      #   text = ''
      #     #! /usr/bin/env ${pkgs.cached-nix-shell}/bin/cached-nix-shell
      #     #! nix-shell -i sh -p lieer
      #     (cd ~/mail/wmruggiano@gmail.com; gmi sync)
      #     (cd ~/mail/will@ruggianofamily.com; gmi sync)
      #   '';
      #   executable = true;
      # };
      #
      # "mail/.notmuch/hooks/post-new" = {
      #   text = ''
      #     #! /usr/bin/env ${pkgs.cached-nix-shell}/bin/cached-nix-shell
      #     #! nix-shell -i sh -p notmuch
      #     notmuch tag -new -- tag:new and from:wmruggiano@gmail.com
      #     notmuch tag -new -- tag:new and from:will@ruggianofamily.com
      #     notmuch tag +inbox +unread -new -- tag:new
      #     notmuch tag -inbox -new -unread -- tag:spam
      #   '';
      #   executable = true;
      # };
    };

    environment.variables = {
      NOTMUCH_CONFIG = "${config.user.home}/.config/notmuch/notmuchrc";
      NMBGIT = "${config.user.home}/.local/share/notmuch/nmbug";
    };
  };
}
