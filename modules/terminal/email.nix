{ options, config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.terminal.email;
in
{
  options.modules.terminal.email = {
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
        text/html; ${pkgs.w3m}/bin/w3m -I %{charset} -T text/html ; copiousoutput; nametemplate=%s.html
      '';
      "neomutt/neomuttrc".source = ../../.config/mutt/neomuttrc;
      "neomutt/signature".text = ''
        Will Ruggiano
      '';
      "neomutt/vim-keys.rc".source = ../../.config/mutt/vim-keys.rc;
      "notmuch/notmuchrc".source = ../../.config/mutt/notmuchrc;
    };

    home.file = {
      "mail/.notmuch/hooks/pre-new".text = ''
        #! /usr/bin/env nix-shell
        #! nix-shell -i sh -p lieer
        (cd ~/mail/wmruggiano@gmail.com; gmi sync)
      '';

      "mail/.notmuch/hooks/post-new".text = ''
        #! /usr/bin/env nix-shell
        #! nix-shell -i sh -p notmuch
        notmuch tag -new -- tag:new and from:wmruggiano@gmail.com
        notmuch tag +inbox +unread -new -- tag:new
      '';
    };

    environment.variables = {
      NOTMUCH_CONFIG = "${config.user.home}/.config/notmuch/notmuchrc";
      NMBGIT = "${config.user.home}/.local/share/notmuch/nmbug";
    };
  };
}
