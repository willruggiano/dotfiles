{
  config,
  pkgs,
  pkgs-latest,
  ...
}: {
  environment = {
    interactiveShellInit = ''
      export ANTHROPIC_API_KEY="$(cat ${config.age.secrets.anthropic.path})"
      export GEMINI_API_KEY="$(cat ${config.age.secrets.gemini.path})"
      export OPENAI_API_KEY="$(cat ${config.age.secrets.openai.path})"
      # For simonw's `llm`:
      export LLM_GEMINI_KEY="$GEMINI_API_KEY"
      # For `goose`:
      export GOOGLE_API_KEY="$GEMINI_API_KEY"
    '';
    systemPackages = let
      llm = with pkgs-latest; [
        (python3.withPackages (ps:
          with ps; [
            datasette
            llm
            llm-anthropic
            llm-docs
            llm-gemini
            llm-gguf
            llm-ollama
          ]))
      ];
      tools = with pkgs; [
        cached-nix-shell
        curl
        fd
        file
        hyperfine
        inetutils
        jq
        mkcert
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
    in
      llm ++ tools;
  };
}
