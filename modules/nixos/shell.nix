{
  config,
  pkgs',
  ...
}: {
  environment = {
    interactiveShellInit = ''
      export ANTHROPIC_API_KEY="$(cat ${config.age.secrets.anthropic.path})"
      export GOOGLE_API_KEY="$(cat ${config.age.secrets.gemini.path})"
      export OPENAI_API_KEY="$(cat ${config.age.secrets.openai.path})"
    '';
    systemPackages = let
      llm = with pkgs'; [
        # (python3.withPackages (ps:
        #   with ps; [
        #     datasette
        #     llm
        #     llm-anthropic
        #     llm-docs
        #     llm-fragments-github
        #     llm-gemini
        #     llm-gguf
        #     llm-ollama
        #   ]))
        # vllm
      ];
      tools = with pkgs'; [
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
    in
      llm ++ tools;
  };
}
