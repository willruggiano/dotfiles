{
  config,
  lib,
  pkgs',
  ...
}: {
  environment = {
    interactiveShellInit = ''
      export ANTHROPIC_API_KEY="$(cat ${config.age.secrets.anthropic.path})"
      export GOOGLE_API_KEY="$(cat ${config.age.secrets.gemini.path})"
      export OPENAI_API_KEY="$(cat ${config.age.secrets.openai.path})"
    '';
    systemPackages = with pkgs'; [
      cached-nix-shell
      curl
      fd
      file
      gdu
      glow
      hyperfine
      inetutils
      jq
      mkcert
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
    shortcut = lib.mkDefault "a";
    secureSocket = lib.mkDefault true;
    terminal = lib.mkDefault "screen256-color";
  };
}
