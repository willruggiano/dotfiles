{
  lib,
  pkgs',
  ...
}: {
  environment = {
    systemPackages = with pkgs'; [
      cached-nix-shell
      curl
      diskus
      fast-cli-zig
      fd
      file
      forgejo-cli
      glow
      hut
      hyperfine
      inetutils
      jq
      lsof
      mkcert
      ncdu
      nq
      (writeShellScriptBin "qq" ''
        nq -c sh -c '"$@"; notify-send "$*: done (exit: $?)"' _ "$@"
      '')
      pandoc
      rclone
      ripgrep
      sad
      sd
      sysz
      timg
      trash-cli
      unzip
      wget
      yq
      zip
      zmx # battling with nq
    ];
  };

  programs = {
    direnv.enable = lib.mkDefault true;
    fish.enable = lib.mkDefault true;
    fzf.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    htop.enable = lib.mkDefault true;

    starship = {
      enable = lib.mkDefault true;
      settings.env_var = builtins.listToAttrs (
        lib.mapAttrsToList (label: var: {
          name = var;
          value = {
            format = "[+${label}:$env_value]($style) ";
            style = "dimmed";
          };
        }) {
          nq = "NQDIR";
          zmx = "ZMX_SESSION";
        }
      );
    };

    tmux = {
      extraConfig = ''
        bind-key C-n next-window
        bind-key C-p previous-window
        set -g mouse on
        set -g visual-activity off
        setw -g monitor-activity on
      '';
      keyMode = "vi";
      secureSocket = lib.mkDefault true;
      terminal = lib.mkDefault "screen256-color";
    };
  };
}
