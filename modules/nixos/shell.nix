{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      cached-nix-shell
      curl
      fd
      file
      hyperfine
      jq
      mkcert
      nodePackages.insect
      # qrcp
      ripgrep
      sad
      speedtest-cli
      sysz
      trash-cli
      unzip
      wget
      yq
      zip
    ];
  };
}
