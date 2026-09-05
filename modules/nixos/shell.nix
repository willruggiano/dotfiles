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
      pandoc
      rclone
      ripgrep
      sad
      sd
      speedtest-cli
      sysz
      timg
      trash-cli
      unzip
      wget
      yq
      zip
    ];
  };

  programs.tmux = {
    extraConfig = ''
      set -g mouse on
      set -g visual-activity on
      setw -g monitor-activity on
    '';
    keyMode = "vi";
    secureSocket = lib.mkDefault true;
    terminal = lib.mkDefault "screen256-color";
  };
}
