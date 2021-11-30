{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.email;
in
{
  options.services.email = {
    enable = mkEnableOption "Enable terminal email (neomutt)";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      lieer
      neomutt
      notmuch
    ];

    home.configFile = {
      "neomutt/mailcap".text = ''
        text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
      '';
      "neomutt/neomuttrc".source = ../../.config/mutt/neomuttrc;
      "neomutt/urlscan".text = ''
        macro index,pager \cb "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
        macro attach,compose \cb "<pipe-entry> ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
      '';
      "neomutt/signature".text = ''
        Will Ruggiano
      '';
      "neomutt/vim-keys.rc".source = ../../.config/mutt/vim-keys.rc;
      "notmuch/notmuchrc".source = ../../.config/mutt/notmuchrc;
    };

    home.file = {
      "mail/.notmuch/hooks/pre-new" = {
        text = ''
          #! /usr/bin/env ${pkgs.cached-nix-shell}/bin/cached-nix-shell
          #! nix-shell -i sh -p lieer
          (cd ~/mail/wmruggiano@gmail.com; gmi sync)
          (cd ~/mail/will@ruggianofamily.com; gmi sync)
        '';
        executable = true;
      };

      "mail/.notmuch/hooks/post-new" = {
        text = ''
          #! /usr/bin/env ${pkgs.cached-nix-shell}/bin/cached-nix-shell
          #! nix-shell -i sh -p notmuch
          notmuch tag -new -- tag:new and from:wmruggiano@gmail.com
          notmuch tag -new -- tag:new and from:will@ruggianofamily.com
          notmuch tag +inbox +unread -new -- tag:new
          notmuch tag -inbox -new -unread -- tag:spam
        '';
        executable = true;
      };
    };

    environment.variables = {
      NOTMUCH_CONFIG = "${config.user.home}/.config/notmuch/notmuchrc";
      NMBGIT = "${config.user.home}/.local/share/notmuch/nmbug";
    };
  };
}
