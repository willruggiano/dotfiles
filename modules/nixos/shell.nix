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
      nq # battling with zmx
      (writeShellScriptBin "q" ''
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

  programs.starship.settings.env_var = {
    NQDIR.format = "[\\(nq:$env_value\\)](dimmed)";
    ZMX_SESSION.format = "[\\(zmx:$env_value\\)](dimmed)";
  };

  programs.tmux = {
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
}
