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
    enable = mkEnableOption "Terminal email via neomutt";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lieer
      neomutt
      notmuch
    ];

    home.configFile = {
      "neomutt/mailcap".text = ''
        text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html; copiousoutput;
      '';
      "neomutt/neomuttrc".text = ''
        set realname = "Will Ruggiano"
        set from = "wmruggiano@gmail.com"
        set signature = "~/.config/neomutt/signature"

        set smtp_url = "smtp://wmruggiano@smtp.gmail.com:587"
        set smtp_pass = "`cat ${config.age.secrets."wmruggiano@gmail.com".path}`"

        set folder = "~/mail"
        set virtual_spoolfile = yes
        virtual-mailboxes "Inbox"       "notmuch://?query=tag:inbox"
        virtual-mailboxes "Updates"     "notmuch://?query=tag:updates"
        virtual-mailboxes "Flagged"     "notmuch://?query=tag:flagged"
        virtual-mailboxes "Important"   "notmuch://?query=tag:important"
        virtual-mailboxes "Draft"       "notmuch://?query=tag:draft"
        virtual-mailboxes "Sent"        "notmuch://?query=tag:sent"

        set postponed = "~/mail/drafts"
        set record = ""

        set sort = threads
        set sort_aux = reverse-last-date-received
        set header_cache = "~/.cache/neomutt/headers"
        set message_cachedir = "~/.cache/neomutt/bodies"

        set sidebar_visible
        set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
        set date_format = "%d/%m/%y %I:%M%p"

        set mailcap_path = "~/.config/neomutt/mailcap"
        auto_view text/html

        source ~/.config/neomutt/vim-keys.rc
        source ~/.config/neomutt/urlscan
      '';
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
